//@dart = 2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/data/dataSources/data_source_contract.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/local_message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
import 'package:sqflite/sqflite.dart';

class LocalSqflite implements IDatasource {
  final Database _chatdb;
  LocalSqflite(this._chatdb);

  @override
  Future<void> addChat(Chat chat) async {
    await _chatdb.insert('chats', chat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> addMessage(LocalMessage message) async {
    await _chatdb.insert('messages', message.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteChat(String chatId) async {
    final batchDeleteTransactions = _chatdb.batch();
    batchDeleteTransactions
        .delete('messages', where: "chat_id = ?", whereArgs: [chatId]);
    batchDeleteTransactions
        .delete('chats', where: 'id = ?', whereArgs: [chatId]);
    batchDeleteTransactions.commit(noResult: true);
  }

  @override
  Future<List<Chat>> findAllChats() {
    return _chatdb.transaction((txn) async {
      final chats =
          await txn.rawQuery('''SELECT messages.* FROM
      (SELECT 
        chat_id, MAX(created_at) AS created_at
       FROM messages
       GROUP BY chat_id
      ) AS latest_messages
      INNER JOIN messages
      ON messages.chat_id = latest_messages.chat_id
      AND messages.created_at = latest_messages.created_at
      ORDER BY messages.created_at DESC''');

      if (chats.isEmpty) return [];

      final chatsUnread =
          await txn.rawQuery('''SELECT chat_id, count(*) as unread 
      FROM messages
      WHERE receipt = ?
      GROUP BY chat_id
      ''', ['deliverred']);

      return chats.map<Chat>((row) {
        final int unread = chatsUnread.firstWhere(
            (ele) => row['chat_id'] == ele['chat_id'],
            orElse: () => {'unread': 0})['unread'];

        final chat = Chat.fromMap({"id": row['chat_id']});
        chat.unread = unread;
        chat.mostRecent = LocalMessage.fromMap(row);
        return chat;
      }).toList();
    });
  }

  @override
   Future<Chat> findChat(String chatId) async {
    return await _chatdb.transaction((txn) async {
      final listOfChatMaps = await txn.query(
        'chats',
        where: 'id = ?',
        whereArgs: [chatId],
      );

      if (listOfChatMaps.isEmpty) return null;

      final unread = Sqflite.firstIntValue(await txn.rawQuery(
          'SELECT COUNT(*) FROM MESSAGES WHERE chat_id = ? AND receipt = ?',
          [chatId, 'deliverred']));

      final mostRecentMessage = await txn.query('messages',
          where: 'chat_id = ?',
          whereArgs: [chatId],
          orderBy: 'created_at DESC',
          limit: 1);
      final chat = Chat.fromMap(listOfChatMaps.first);
      chat.unread = unread;
      chat.mostRecent = LocalMessage.fromMap(mostRecentMessage.first);
      return chat;
    });
  }

  @override
  Future<List<LocalMessage>> findMessages(String chatId) async {
    final listOfMaps = await _chatdb.query(
      'messages',
      where: 'chat_id = ?',
      whereArgs: [chatId],
    );

    return listOfMaps
        .map<LocalMessage>((map) => LocalMessage.fromMap(map))
        .toList();
  }

  @override
  Future<void> updateMessage(LocalMessage message) async {
    await _chatdb.update('messages', message.toMap(),
        where: 'id = ?',
        whereArgs: [message.message.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status) {
    return _chatdb.transaction((txn) async {
      await txn.update('messages', {'receipt': status.value()},
          where: 'id = ?',
          whereArgs: [messageId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}