import 'package:book_my_spot_frontend/src/utils/helpers/error_handler.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserException implements Exception {
  final String error;
  final ErrorTypes types;
  UserException(this.types, this.error);
  String errorMessage() {
    return "Oops , error : ${error}";
  }

  void errorHandler(BuildContext context, WidgetRef ref) {
    ErrorManager.errorHandler(types, context, ref);
  }
}
