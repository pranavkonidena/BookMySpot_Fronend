import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityEventTeamsList extends ConsumerWidget {
  const AmenityEventTeamsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leading: IconButton(
            onPressed: () {
              context.go("/head");
            },
            icon: Icon(Icons.arrow_back_ios_new_outlined , color: Colors.grey[700],)),
        title: const Text(
          "Event Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
      body: Center(child: Text("See ur teams here!")),
    );
  }
}
