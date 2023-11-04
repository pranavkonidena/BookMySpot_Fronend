import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:book_my_spot_frontend/src/constants/constants.dart';

class ChatPage extends ConsumerStatefulWidget {
  ChatPage(this.id, {super.key});
  String id;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final _channel =
      WebSocketChannel.connect(Uri.parse('ws://${using}'));
  
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
        children: [Text("See chats here!")],
      ),
    );
  }
}
