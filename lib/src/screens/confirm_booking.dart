import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:go_router/go_router.dart';

class ConfirmBooking extends ConsumerWidget {
  const ConfirmBooking(this.id, {super.key});
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        Center(
          child: Text(id.toString()),
        ),
        ElevatedButton(
            onPressed: () {
              ref.read(currentIndexProvider.notifier).state = 0;
              context.go("/");
              
            },
            child: Text("Cancel")),
        ElevatedButton(
            onPressed: () {
              ref.read(currentIndexProvider.notifier).state = 0;
              context.go("/");
              
            },
            child: Text("Confirm"))
      ],
    ));
  }
}
