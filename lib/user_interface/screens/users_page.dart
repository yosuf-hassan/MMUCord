//@dart=2.9
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/user_interface/widgets/users_page/profile_image.dart';
// ignore: import_of_legacy_library_into_null_safe


// ignore: camel_case_types
class usersPage extends StatefulWidget {
  usersPage();

  // ignore: empty_constructor_bodies
  @override
  _usersPageState createState() => _usersPageState();
}

// ignore: camel_case_types
class _usersPageState extends State<usersPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(appBar: AppBar(title: Container(width: double.maxFinite,child: Row(children: [ProfileImageW(url:"https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/c6dc5bd6-960f-4244-8665-e0177f0ac3b6/dcjufl7-8f620af3-5d02-4487-9d04-64fae8bc49e8.jpg/v1/fill/w_1600,h_1600,q_75,strp/henry_of_skalitz___kingdom_come_deliverance_by_suzanna8767_dcjufl7-fullview.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTYwMCIsInBhdGgiOiJcL2ZcL2M2ZGM1YmQ2LTk2MGYtNDI0NC04NjY1LWUwMTc3ZjBhYzNiNlwvZGNqdWZsNy04ZjYyMGFmMy01ZDAyLTQ0ODctOWQwNC02NGZhZThiYzQ5ZTguanBnIiwid2lkdGgiOiI8PTE2MDAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.5Erx63rqQsagjWOqDRRlpplTlWzMN5VbtQflhV4xTK8",online: true,),Column(children: [Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text("Henry",style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14.0,fontWeight: FontWeight.bold,),),
    ),Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Text("Online",style: Theme.of(context).textTheme.caption),),
    ],)],),),bottom: TabBar(indicatorPadding: EdgeInsets.only(top: 10.0,bottom: 10.0),tabs: [Tab(child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(50),),child: Align(alignment: Alignment.center,child: Text("Messages"),),),),Tab(child: Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(50),),child: Align(alignment: Alignment.center,child: Text("Active"),),),)],),),body: TabBarView(children: [Container(),Container()],),));
  }
}