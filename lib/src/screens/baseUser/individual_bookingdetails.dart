import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

final bookingDetailsProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse(using +
      "booking/individual/specificBooking?id=${ref.watch(dataIndexProvider)}"));
  var data = jsonDecode(response.body);
  return data;
});

class IndividualBookingDetails extends ConsumerWidget {
  IndividualBookingDetails(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(bookingDetailsProvider);
    return data.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.height / 12,
            elevation: 0,
            backgroundColor: const Color.fromARGB(168, 35, 187, 233),
            // leadingWidth: 220,
            leading: IconButton(
              onPressed: () {
                context.go("/");
              },
              icon: Icon(Icons.arrow_back_ios_new_outlined),
              color: Colors.grey[700],
            ),
            title: Text(
              "Booking Details",
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontFamily: 'Thasadith',
              ),
            ),
          ),
          body: Column(
            children: [
              Center(
                child: Text(DateTime.parse(data[0]["timestamp_of_booking"])
                    .subtract(Duration(minutes: 90))
                    .toString()),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await http.get(Uri.parse(using +
                        "booking/individual/cancelSlot?booking_id=${id}"));
                    ref.refresh(userBookingsProvider);
                    context.go("/");
                  },
                  child: Text("Cancel"))
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () {
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
