//@dart =2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
import 'package:mmucord/data/dataSources/data_source_contract.dart';
import 'package:mmucord/models/local_message.dart';
import 'package:mmucord/view_models/base_model.dart';
// ignore: import_of_legacy_library_into_null_safe


class ChatViewModel extends BaseViewModel {
  IDatasource _datasource;
  String _chatId = '';
  int otherMessages = 0;
  String get chatId => _chatId;

  ChatViewModel(this._datasource) : super(_datasource);

  Future<List<LocalMessage>> getMessages(String chatId) async {
    final messages = await _datasource.findMessages(chatId);
    if (messages.isNotEmpty) {
      _chatId = chatId;
    }
    return messages;
  }

  Future<void> sentMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.to, message, ReceiptStatus.sent);
    if (_chatId.isNotEmpty) {
      return await _datasource.addMessage(localMessage);
    } else {
      _chatId = localMessage.chatId;
    }
    await addMessage(localMessage);
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    if (_chatId.isEmpty) _chatId = localMessage.chatId;
    if (localMessage.chatId != _chatId) otherMessages++;
    await addMessage(localMessage);
  }

  Future<void> updateMessageReceipt(Receipt receipt) async {
    await _datasource.updateMessageReceipt(receipt.messageId, receipt.status);
  }
}
