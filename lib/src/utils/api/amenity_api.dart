import 'package:book_my_spot_frontend/src/screens/auth/login.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityAPIEndpoint {
  AmenityAPIEndpoint._();

  static AmenityAuth(BuildContext context, WidgetRef ref) async {
    String email = ref.watch(emailProvider);
    String password = ref.watch(passwordProvider);

    var authHeader = {"email": email, "password": password};
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.amenity, "head/auth", authHeader);
    saveAdminToken(response.data);
    if (response.statusCode == 200) {
      Future.microtask(() => context.go("/head"));
    } else {
      throw AuthException("Invalid Credentials");
    }
  }
}
