import 'package:book_my_spot_frontend/src/models/moduser.dart';
import 'package:book_my_spot_frontend/src/services/storage_manager.dart';
import 'package:book_my_spot_frontend/src/state/amenityhead/amenityhead_state.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/amenity/amenity_exception.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityAPIEndpoint {
  AmenityAPIEndpoint._();

  static Future<void> amenityAuth(BuildContext context, WidgetRef ref,
      String email, String password) async {
    var authHeader = {"email": email, "password": password};
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.amenity, "head/auth", authHeader);

    if (response.statusCode == 200) {
      StorageManager.saveAdminToken(response.data);
      ModUser modUser = ModUser(response.data);
      modUser.email = email;
      ref.read(modUserProvider.notifier).state = modUser;
      Future.microtask(() => context.go("/head"));
    } else {
      throw AuthException("Invalid Credentials");
    }
  }

  static Future<void> createEvent(var postData) async {
    debugPrint("RE");
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.amenity, "head/makeEvent", postData);
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 200) {
      throw AmenityException(ErrorTypes.eventCreation);
    }
  }

  static Future<Response> fetchAmenityBookigs() async {
    var token = StorageManager.getAdminToken();
    var response = await HttpHelper.makeRequest(
        RequestTypes.get, RequestGroup.amenity, "getAllBookings?id=$token");
    for (int i = 0; i < response.data.length; i++) {
      response.data[i]["time_of_slot"] =
          DateTime.parse(response.data[i]["time_of_slot"]);
      response.data[i]["end_time"] = response.data[i]["time_of_slot"]
          .add(Duration(minutes: response.data[i]["duration_of_booking"]));
    }
    if (response.statusCode == 200) {
      return response;
    } else {
      throw UserException(
          ErrorTypes.bookings, "Error while fetching amenity bookings");
    }
  }

  static Future<void> revokeIndividualBooking(var deleteData) async {
    await HttpHelper.makeRequest(RequestTypes.delete, RequestGroup.booking,
        "individual/cancelSlot", deleteData);
  }

  static Future<void> revokeGroupBooking(var deleteData) async {
    await HttpHelper.makeRequest(RequestTypes.delete, RequestGroup.booking,
        "group/cancelSlot", deleteData);
  }
}
