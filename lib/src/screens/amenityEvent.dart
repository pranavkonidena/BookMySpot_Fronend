import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityEventAdd extends ConsumerStatefulWidget {
  const AmenityEventAdd({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AmenityEventAddState();
}

class _AmenityEventAddState extends ConsumerState<AmenityEventAdd> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Lessgoo")),
    );
  }
}