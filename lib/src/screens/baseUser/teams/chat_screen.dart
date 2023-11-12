import 'dart:async';
import 'dart:convert';
import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
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
  late WebSocketChannel channel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Schedule a microtask to scroll to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scrollController.hasClients) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    }
  });
  }

  @override
  void initState() {
    channel =
        WebSocketChannel.connect(Uri.parse("ws://${IP}/ws/chat/${widget.id}"));
    super.initState();
  }

  final scrollController = ScrollController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      User user = ref.watch(userProvider);
      channel.sink.add(jsonEncode(
          {"message": _controller.text.toString(), "id": user.token}));
      _controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          backgroundColor: const Color.fromARGB(168, 35, 187, 233),
          leading: IconButton(
              onPressed: () {
                context.go("/teamDetails${widget.id}");
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[700],
              )),
          title: Text(
            "Chat",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontFamily: 'Thasadith',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final chats = jsonDecode(snapshot.data.toString());
                  if (scrollController.hasClients) {
                    print("EXE");
                    scrollController.jumpTo(0);
                  } else {
                    print("WILL BE EXE");
                    scheduleMicrotask(() {
                      scrollController.jumpTo(0);
                    });
                    Timer(Duration(milliseconds: 600), () {
                      scrollController.jumpTo(0);
                    });
                  }
                  return ListView.separated(
                    controller: scrollController,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: chats.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 20,
                      );
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        child: Text(chats[index].toString()),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: TextFormField(
                    controller: _controller,
                    decoration:
                        const InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  tooltip: 'Send message',
                  icon: const Icon(
                    Icons.send,
                    size: 15,
                  ),
                ), // This trailing
              ],
            ),
          ]),
        ));
  }
}
