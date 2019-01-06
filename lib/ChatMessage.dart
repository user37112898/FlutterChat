import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  String text;
  ChatMessage(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Text(text),
    );
  }
}