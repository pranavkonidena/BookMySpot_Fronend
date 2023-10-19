import 'package:book_my_spot_frontend/src/screens/confirm_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class BookingPageFinal extends ConsumerWidget {
  const BookingPageFinal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(slotsProviderAmenity);
    return Scaffold(
      body: Center(child: Text(data.toString())),
    );
  }
}