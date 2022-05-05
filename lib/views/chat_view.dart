import 'dart:io';

import 'package:app_workspace_chat/widgets/chat_message_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {

  final _ctrTextEdit = TextEditingController();
  final _focusNote = FocusNode();
  bool _isWriting = false;

  List<ChatMessageWidget> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: const Text('Te', style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[300]!,
              maxRadius: 14,
            ),
            const SizedBox(height: 3,),
            const Text(
              'Jose Madero', 
              style: TextStyle(
                color: Colors.black87,
                fontSize: 10
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SizedBox(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: messages.length,
                itemBuilder: (_, i) => messages[i],
                reverse: true,
              )
            ),
            const Divider(height: 1,),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
     ),
   );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _ctrTextEdit,
                onSubmitted: _listeningMessages,
                onChanged: (String texto) {
                  setState(() {
                    if (texto.trim().isNotEmpty) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    } 
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focusNote,
              )
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: (Platform.isIOS)
              ? CupertinoButton(
                child: const Text('Enviar'), 
                onPressed: _isWriting
                ? () => _listeningMessages(_ctrTextEdit.text.trim())
                : null,
              )
              : Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: IconTheme(
                  data: IconThemeData(color: Colors.blue[400]),
                  child: IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    icon: const Icon(Icons.send),
                    onPressed: _isWriting
                    ? () => _listeningMessages(_ctrTextEdit.text.trim())
                    : null,
                  ),
                ),
              )
            )
          ],
        ),
      )
    );
  }

  _listeningMessages(String texto) {
    if (texto.isEmpty) return;
    _ctrTextEdit.clear();
    _focusNote.requestFocus();
    final newMessage = ChatMessageWidget(
      uid: '123', 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });
  }

  @override
  void dispose() {
    // TODO: off socket
    for(ChatMessageWidget message in messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}