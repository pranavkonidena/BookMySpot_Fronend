import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './home.dart';
class MakeReservationPage extends ConsumerWidget {
  const MakeReservationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Text("Make reservation page"),
    );
  }
}