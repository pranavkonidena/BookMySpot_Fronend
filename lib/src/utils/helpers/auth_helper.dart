import 'package:book_my_spot_frontend/src/models/response.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/home.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AuthHelper {
  AuthHelper._();

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
}
