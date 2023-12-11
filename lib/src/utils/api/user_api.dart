import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/state/navbar/navbar_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:book_my_spot_frontend/src/services/storage_manager.dart';
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

  static Future<void> userLogin(Response response, WidgetRef ref) async {
    if (response.statusCode == 200) {
      StorageManager.saveToken(response.data);
      User user = await ref.watch(userFutureProvider.future);
      ref.read(userProvider.notifier).state = user;
    } else {
      throw AuthException(response.data);
    }
  }

  static void userLogout(BuildContext context, WidgetRef ref) {
    StorageManager.deleteToken();
    ref.watch(currentIndexProvider.notifier).state = 0;
    context.go("/login");
  }

  static Future<Response> fetchUserBookings(WidgetRef ref) async {
    User? user = ref.watch(userProvider);
    String token = user!.token;
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
      return response;
    }
  }
}
