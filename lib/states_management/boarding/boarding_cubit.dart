//@dart=2.9

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:mmucord/data/services/image_upload.dart';
import 'package:mmucord/states_management/boarding/boarding_state.dart';

// ignore: camel_case_types
class boardingCubit extends Cubit<boardingState> {
  final IUserService _userService;
  final ImageUploader _imageUploader;

  boardingCubit(this._userService, this._imageUploader)
      : super(boardingInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploader.uploadImage(profileImage);
    final user = User(
      username: name,
      photoUrl: url,
      active: true,
      lastseen: DateTime.now(),
    );
    final createdUser = await _userService.connect(user);
    emit(boardingSuccess(createdUser));
  }
}
