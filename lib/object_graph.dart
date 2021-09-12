//@dart=2.9


import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmucord/data/services/image_upload.dart';
import 'package:mmucord/states_management/boarding/boarding_cubit.dart';
import 'package:mmucord/states_management/boarding/profile_image_cubit.dart';
import 'package:mmucord/user_interface/screens/boarding.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';

class ObjectGraph {
  static Rethinkdb _r;
  static Connection _connection;
  static IUserService _userService;

  static bootstrap() async {
    _r = Rethinkdb();
    _connection = await _r.connect(host: '192.168.0.133', port: 28015); // connect on 10.0.2.2 because the emulator uses this IP for loopback address
    _userService = UserService(_r, _connection);
  }

  static Widget composeBoardingUI() {
    ImageUploader imageUploader =
        ImageUploader('http://192.168.0.133:8000');
    // ignore: non_constant_identifier_names
    boardingCubit boarding_cubit = boardingCubit(_userService, imageUploader);
    // ignore: non_constant_identifier_names
    ProfileImageCubit image_cubit = ProfileImageCubit();
    return MultiBlocProvider(providers:[BlocProvider(create: (BuildContext context)=>boarding_cubit),BlocProvider(create: (BuildContext context)=>image_cubit)],child: Boarding(),);
  }
}
