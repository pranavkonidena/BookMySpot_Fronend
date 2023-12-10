import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/amenity/amenity_exception.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmenityAPIEndpoint {
  AmenityAPIEndpoint._();

  static Future<void> amenityAuth(
      BuildContext context, String email, String password) async {
    var authHeader = {"email": email, "password": password};
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.amenity, "head/auth", authHeader);

    if (response.statusCode == 200) {
      StorageManager.saveAdminToken(response.data);
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
}
