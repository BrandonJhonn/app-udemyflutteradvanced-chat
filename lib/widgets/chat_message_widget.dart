import 'package:flutter/material.dart';

class ChatMessageWidget extends StatelessWidget {

  final String uid;
  final String texto;
  final AnimationController animationController;

  const ChatMessageWidget({ 
    Key? key,
    required this.uid,
    required this.texto,
    required this.animationController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.easeOut
        ),
        child: Container(
          child: uid == '123'
          ? _myMessage()
          : _otherMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 10, bottom: 5, left: 60),
        child: Text(texto, style: const TextStyle(color: Colors.white),),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  Widget _otherMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(right: 60, bottom: 5, left: 10),
        child: Text(texto, style: const TextStyle(color: Colors.black87),),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}