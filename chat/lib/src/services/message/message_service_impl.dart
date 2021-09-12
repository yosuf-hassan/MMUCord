//@dart=2.9
import 'dart:async';

// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/message.dart';
import 'package:chat/src/services/encryption/encryption_contract.dart';
import 'package:chat/src/services/encryption/encryption_service_impl.dart';
import 'package:chat/src/services/message/message_service_contract.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class MessageService implements IMessageService {
  final Connection _connection;
  final Rethinkdb r;
  StreamSubscription _changefeed;
  final _controller = StreamController<Message>.broadcast();
  final IEncryption _encryption;
  MessageService(this.r, this._connection, this._encryption, {EncryptionService encryption});

  @override
  dispose() {
    _controller?.close();
  }

  @override
  Stream<Message> messages({User activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(Message message) async {
    var data = message.toJson();
    data['contents'] = _encryption.encrypt(message.contents);

    Map record = await r.table('messages').insert(data).run(_connection);
    return record['inserted'] == 1;
  }

  _startReceivingMessages(User activeUser) {
    _changefeed = r
        .table('messages')
        .filter({'to': activeUser.id})
        .changes({'include_initial': true})
        .run(_connection)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) {
                  return;
                }
                final message = _messageFromFeed(feedData);
                _controller.sink.add(message);
                _removeDeliveredMessage(message);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  Message _messageFromFeed(feedData) {
    var data = feedData['new_val'];
    data['contents'] = _encryption.decrypt(data['contents']);
    return Message.fromJson(data);
  }

  _removeDeliveredMessage(message) {
    r
        .table('messages')
        .get(message.id)
        .delete({'return_changes': false}).run(_connection);
  }
}
