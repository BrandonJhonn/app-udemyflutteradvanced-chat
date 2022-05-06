import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/messages_response_model.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';
import '../services/auth_service.dart';
import '../widgets/chat_message_widget.dart';


class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {

  final _ctrTextEdit = TextEditingController();
  final _focusNote = FocusNode();
  bool _isWriting = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessageWidget> messages = [];

  @override
  void initState() {
    super.initState();

    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _listenMenssage);

    _getHistorial(chatService.destinatario.uid);
  }

  void _getHistorial(String uid) async {
    List<Mensaje> chat = await chatService.getChat(uid);
    final history = chat.map((m) => ChatMessageWidget(
      uid: m.de, 
      texto: m.mensaje, 
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 0)
        )..forward()
      ),
    );

    setState(() {
      messages.insertAll(0, history);
    });
  }

  void _listenMenssage(dynamic payload) {
    ChatMessageWidget message = ChatMessageWidget(
      uid: payload['de'], 
      texto: payload['mensaje'], 
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300)
      )
    );
    setState(() {
      messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final destinatario = chatService.destinatario;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              child: Text(destinatario.nombre.substring(0,2), style: const TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[300]!,
              maxRadius: 14,
            ),
            const SizedBox(height: 3,),
            Text(
              destinatario.nombre, 
              style: const TextStyle(
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
      uid: authService.usuario.uid, 
      texto: texto,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );
    messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() { _isWriting = false; });

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.destinatario.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for(ChatMessageWidget message in messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}