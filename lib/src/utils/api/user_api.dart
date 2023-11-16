import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/models/user.dart';
import '../enums/request_types.dart';
import '../enums/request_groups.dart';

class UserAPIEndpoint {
  UserAPIEndpoint._();

  static userLogin(Response response) {
    if (response.statusCode == 200) {
      saveToken(response.data);
    } else {
      throw AuthException(response.data);
    }
  }

  static userLogout(BuildContext context, WidgetRef ref) {
    deleteToken();
    ref.watch(currentIndexProvider.notifier).state = 0;
    context.go("/login");
  }

  static fetchUserBookings(WidgetRef ref) async {
    User user = ref.watch(userProvider);
    String token = user.token;
    final date = ref.watch(focusedProvider);
    var postBody = {
      "id": token,
      "date": "${date.year}-${date.month}-${date.day}"
    };
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.user, "getBooking", postBody);

    if (response.statusCode != 200) {
      throw UserException(
          ErrorTypes.bookings, "Error while fetching bookings!");
    } else {
      return response.data;
    }
  }

  static fetchUserDetails(String uid) async {
    Response response = await HttpHelper.makeRequest(
        RequestTypes.get, RequestGroup.user, "?id=$uid");
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw UserException(ErrorTypes.unknown, "Error fetching user data!");
    }
  }
}
