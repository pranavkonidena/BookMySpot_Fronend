import 'dart:convert';

import 'package:book_my_spot_frontend/src/models/booking.dart';
import 'package:book_my_spot_frontend/src/utils/api/amenity_api.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AmenityHeadNotifier extends StateNotifier<List<Booking>> {
  AmenityHeadNotifier() : super([]);

  Future<List<Booking>> fetchAmenityBookings() async {
    Response response = await AmenityAPIEndpoint.fetchAmenityBookigs();
    var data = response.data;
    for (int i = 0; i < data.length; i++) {
      try {
        data[i] = jsonDecode(data[i].toString());
      } catch (e) {
        debugPrint(e.toString());
      }
      data[i]["end_time"] = data[i]["time_of_slot"]
          .add(Duration(minutes: data[i]["duration_of_booking"]));
    }
    List<Booking> amenityBookings = [];
    for (int i = 0; i < data.length; i++) {
      Booking booking = Booking();
      print(data[i]);
      booking = await booking.bookingFromJson(data[i]);
      amenityBookings.add(booking);
    }
    state = amenityBookings;
    debugPrint("Retuend");
    return amenityBookings;
  }
}

final amenityHeadProvider =
    StateNotifierProvider<AmenityHeadNotifier, List<Booking>>((ref) {
  return AmenityHeadNotifier();
});
