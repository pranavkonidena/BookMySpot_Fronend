import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/newReservation/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/booking_api.dart';
import 'package:book_my_spot_frontend/src/utils/api/user_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

class BookingNotifier extends StateNotifier<List<Booking>> {
  BookingNotifier() : super([]);

  Future<List<Booking>?> getUserBookings(
      BuildContext context, WidgetRef ref) async {
    try {
      var data = await UserAPIEndpoint.fetchUserBookings(ref);
      for (int i = 0; i < data.length; i++) {
        try {
          data[i] = jsonDecode(data[i].toString());
        } catch (e) {
          print("ERROR");
        }
        data[i]["time_of_slot"] = DateTime.parse(data[i]["time_of_slot"]);
        data[i]["end_time"] = data[i]["time_of_slot"]
            .add(Duration(minutes: data[i]["duration_of_booking"]));
      }
      List<Booking> userBookings = [];
      for (int i = 0; i < data.length; i++) {
        Booking booking = Booking();
        booking = await booking.bookingFromJson(data[i]);
        userBookings.add(booking);
      }
      state = userBookings;
      return userBookings;
    } on UserException catch (e) {
      if (context.mounted) {
        e.errorHandler(ref);
      }
    }
    return null;
  }

  void addBooking(Booking booking) {
    state = [...state, booking];
  }

  Future<void> cancelIndividualBooking(
      BuildContext context, WidgetRef ref, int bookingId) async {
    try {
      await BookingAPIEndpoint.cancelIndividualBooking(bookingId);
      state = [
        for (Booking booking in state)
          if (booking.id != bookingId) booking
      ];
    } on UserException catch (e) {
      if (context.mounted) {
        e.errorHandler(ref);
      }
    }
  }

  Future<void> cancelGroupBooking(
      BuildContext context, WidgetRef ref, int bookingId) async {
    try {
      await BookingAPIEndpoint.cancelGroupBooking(bookingId);
      state = [
        for (Booking booking in state)
          if (booking.id != bookingId) booking
      ];
    } on UserException catch (e) {
      if (context.mounted) {
        e.errorHandler(ref);
      }
    }
  }

  Booking? getBookingDetails(int bookingID) {
    for (Booking booking in state) {
      print(booking.timeOfSlot);
      if (booking.id == bookingID) {
        return booking;
      }
    }
    return null;
  }
}

final userBookingsProvider =
    StateNotifierProvider<BookingNotifier, List<Booking>>((ref) {
  return BookingNotifier();
});
