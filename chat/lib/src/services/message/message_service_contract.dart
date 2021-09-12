// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';
import 'package:flutter/material.dart';

abstract class IMessageService {
  Future<bool> send(Message message);
  Stream<Message> messages({@required User activeUser});
  dispose();
}
