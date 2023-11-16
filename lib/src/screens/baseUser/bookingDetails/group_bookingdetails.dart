import 'dart:convert';
import 'package:book_my_spot_frontend/src/services/string_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home/home.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/state/bookings/booking_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import '../../../constants/constants.dart';
import 'package:go_router/go_router.dart';

class GroupBookingDetails extends ConsumerWidget {
  GroupBookingDetails(this.id, {super.key});
  String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Booking? booking = ref
        .watch(userBookingsProvider.notifier)
        .getBookingDetails(int.parse(id));
    print(booking!.groupMembers.toString());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        title: Text("Booking Details"),
        leading: IconButton(
            onPressed: () {
              context.go("/");
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.grey.shade700,
            )),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Time Of Slot",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 18),
                ),
                Text(
                  "${booking!.timeOfSlot.day} ${months[booking.timeOfSlot.month]} ${booking.timeOfSlot.year} , ${booking.timeOfSlot.hour} : ${booking.timeOfSlot.minute} - ${booking.endOfSlot.hour} : ${booking.endOfSlot.minute}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Booked At",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 18),
                ),
                Text(
                  "${booking!.timestampOfBooking.day} ${months[booking.timestampOfBooking.month]} ${booking.timestampOfBooking.year} , ${booking.timestampOfBooking.hour} : ${booking.timestampOfBooking.minute}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400, fontSize: 18),
                ),
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
                      child: Text(
                        booking.amenityName,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400, fontSize: 22),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Venue",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        Text(booking.amenityVenue,
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Type",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        Text(booking.type.capitalize(),
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30.0, right: 30, top: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Name",
                          style: GoogleFonts.poppins(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        Text(booking.groupName,
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w300)),
                      ],
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              actions: [
                                ElevatedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Text("Ok"))
                              ],
                              content: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < booking.groupMembers.length;
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                booking
                                                    .groupMembers[i].profilePic,
                                                height: 36,
                                                width: 36,
                                              ),
                                            ),
                                          ),
                                          Text(booking.groupMembers[i].name)
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text("View Members"))
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
                  fontSize: 13),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: QrImageView(
              data: booking.id.toString(),
              size: 300,
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(38.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(255, 97, 50, 1)),
                      onPressed: () async {
                        // context.go("/");
                        // await ref
                        //     .read(userBookingsProvider.notifier)
                        //     .cancelBooking(context, ref, int.parse(id));
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
                                          .cancelGroupBooking(
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
