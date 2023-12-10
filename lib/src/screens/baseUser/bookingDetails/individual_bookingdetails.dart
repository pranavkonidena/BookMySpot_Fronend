import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/services/string_extension.dart';
import 'package:book_my_spot_frontend/src/state/bookings/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class IndividualBookingDetails extends ConsumerWidget {
  const IndividualBookingDetails(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Booking? booking = ref
        .watch(userBookingsProvider.notifier)
        .getBookingDetails(ref.watch(dataIndexProvider));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              context.go("/");
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined),
            color: Theme.of(context).iconTheme.color),
        title: Text(
          "Booking Details",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Time Of Slot",
                          style: Theme.of(context).textTheme.titleMedium),
                      Text("Booked At",
                          style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ),
                SizedBox(
                  height: 47,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          "${booking!.timeOfSlot.day} ${months[booking.timeOfSlot.month]} ${booking.timeOfSlot.year} , ${booking.timeOfSlot.hour} : ${booking.timeOfSlot.minute} - ${booking.endOfSlot.hour} : ${booking.endOfSlot.minute}",
                          style: Theme.of(context).textTheme.titleSmall),
                      Text(
                          "${booking.timestampOfBooking.day} ${months[booking.timestampOfBooking.month]} ${booking.timestampOfBooking.year} , ${booking.timestampOfBooking.hour} : ${booking.timestampOfBooking.minute}",
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14.0),
            child: Container(
              color: const Color(0xFFF1F8FB),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Center(
                      child: Text(booking.amenityName,
                          style: Theme.of(context).textTheme.headlineMedium),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Venue",
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(booking.amenityVenue,
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, right: 30, top: 14, bottom: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Type",
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(booking.type.capitalize(),
                            style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 36.0),
            child: Text(
              "Present this QR to avail booking",
              style: GoogleFonts.poppins(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                  fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: QrImageView(
              data: booking.id.toString(),
              size: 370,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 38.0, right: 38, bottom: 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 97, 50, 1)),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: const Text(
                                  "Do you want to cancel your booking?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("No")),
                                ElevatedButton(
                                    onPressed: () async {
                                      await ref
                                          .read(userBookingsProvider.notifier)
                                          .cancelIndividualBooking(
                                              context, ref, int.parse(id));
                                      Future.microtask(() => context.go("/"));
                                    },
                                    child: const Text("Yes"))
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        "Cancel Reservation",
                        style: GoogleFonts.poppins(color: Colors.black),
                      )),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
