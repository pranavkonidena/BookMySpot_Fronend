import 'dart:async';
import 'package:book_my_spot_frontend/src/constants/snackbars/booking_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/insufcred_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/noslotselected_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/teamleaving_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/unknownerror_snackbar.dart';
import 'package:book_my_spot_frontend/src/routes/router_config.dart';
import 'package:book_my_spot_frontend/src/state/errors/error_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/auth_snackbar.dart';

class ErrorManager {
  ErrorManager._();
  static void errorHandler(WidgetRef ref, BuildContext context) {
    StreamController<ErrorTypes> controller =
        ref.watch(errorStreamControllerProvider);
    Stream stream = controller.stream;
    stream.listen((types) {
      switch (types) {
        case ErrorTypes.auth:
          Future.microtask(() => router.go("/login"));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(authsnackBar);
          }
          break;
        case ErrorTypes.insufficientCredits:
          Future.microtask(() => router.go("/"));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(insufcredSnackbar);
            break;
          }
        case ErrorTypes.noSlotSelected:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(noSlotSelectedSnackbar);
            break;
          }

        case ErrorTypes.bookings:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(bookingErrorSnackbar);
            break;
          }
        case ErrorTypes.unknown:
          print("OUTSIDE FN CALL");
          if (context.mounted) {
            print("INSIDE SNACKBAR CODE");
            ScaffoldMessenger.of(context).showSnackBar(unknownerrorSnackbar);
            break;
          }
        case ErrorTypes.leavingTeam:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(teamleavingSnackbar);
            break;
          }
        default:
      }
    });
  }
}
