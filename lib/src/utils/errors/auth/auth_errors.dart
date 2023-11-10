import 'package:book_my_spot_frontend/src/state/errors/error_handler.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthException implements Exception {
  final String error;
  AuthException(this.error);
  String errorMessage() {
    return "Oops , Error : ${error}";
  }

  void errorHandler(BuildContext context, WidgetRef ref) {
    ErrorManager.errorHandler(ErrorTypes.auth, context, ref);
  }
}