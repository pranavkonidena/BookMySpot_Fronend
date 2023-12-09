import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble(
      {Key? key,
      required this.text,
      required this.isCurrentUser,
      required this.sender,
      required this.timeStamp})
      : super(key: key);
  final String text;
  final bool isCurrentUser;
  final String sender;
  final DateTime timeStamp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color.fromARGB(168, 35, 187, 233) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: 0.7*MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(sender , style: const TextStyle(fontSize: 10),)),
                  Text(
                    text,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                        "${timeStamp.day}/${timeStamp.month}/${timeStamp.year} ${timeStamp.hour} ${timeStamp.minute}" , style: TextStyle(fontSize: 10),),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
