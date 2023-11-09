import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/auth_snackbar.dart';

class ErrorManager {
  ErrorManager._();
  static void errorHandler(
      ErrorTypes types, BuildContext context, WidgetRef ref) {
    switch (types) {
      case ErrorTypes.auth:
        Future.microtask(() => context.go("/login"));
        ScaffoldMessenger.of(context).showSnackBar(authsnackBar);
        break;
      default:
    }
  }
}
