import 'package:book_my_spot_frontend/src/constants/snackbars/insufcred_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/noslotselected_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/unknownerror_snackbar.dart';
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
      case ErrorTypes.insufficientCredits:
        Future.microtask(() => context.go("/"));
        ScaffoldMessenger.of(context).showSnackBar(insufcredSnackbar);
      case ErrorTypes.noSlotSelected:
        ScaffoldMessenger.of(context).showSnackBar(noSlotSelectedSnackbar);
      case ErrorTypes.unknown:
        ScaffoldMessenger.of(context).showSnackBar(unknownerrorSnackbar);
      default:
    }
  }
}
