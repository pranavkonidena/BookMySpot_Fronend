import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';

class ChatPage extends ConsumerStatefulWidget {
  ChatPage(this.id, {super.key});
  String id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final channel =WebSocketChannel.connect(Uri.parse("ws://${IP}/ws/chat/16"));
  @override
  // void initState() {
  //   // TODO: implement initState
  //   var channel =WebSocketChannel.connect(Uri.parse("ws://${IP}/ws/chat/16"));
  //   super.initState();
  // }
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      channel.sink.add(
       jsonEncode({"message" : _controller.text.toString()})
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.go("/teamDetails${widget.id}");
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
            child: TextFormField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Send a message'),
            ),
          ),
          StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                return Text(snapshot.hasData ? '${snapshot.data}' : '');
              },
            ),
          FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma mak
        ],
      ),
    );
  }
}
