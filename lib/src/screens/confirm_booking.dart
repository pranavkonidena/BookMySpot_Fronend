import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmBooking extends ConsumerWidget {
  const ConfirmBooking(this.id, {super.key});
  final String? id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(id.toString());
  }
}
