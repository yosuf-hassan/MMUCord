import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  Messages();

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (_, index)=>_chat(), separatorBuilder: (_,_)=>Divider(), itemCount: 3);
    
  }

  _chat()=>{ListTile()};
}
