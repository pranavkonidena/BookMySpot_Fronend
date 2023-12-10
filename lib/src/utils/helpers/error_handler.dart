import 'dart:async';
import 'package:book_my_spot_frontend/src/constants/snackbars/booking_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/deleteteam_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/eventcreation_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/fetchingteams_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/insufcred_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/invalidteamname_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/noslotselected_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/notadmin_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/removinguserfrmteam_snackbar.dart';
import 'package:book_my_spot_frontend/src/constants/snackbars/teamcreation_snackbar.dart';
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(unknownerrorSnackbar);
            break;
          }
        case ErrorTypes.leavingTeam:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(teamleavingSnackbar);
            break;
          }
        case ErrorTypes.fetchingTeams:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(fetchingTeamsSnackbar);
          }
          break;
        case ErrorTypes.notAdmin:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(notAdminSnackbar);
          }
          break;
        case ErrorTypes.deletingTeam:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(deleteteamSnackbar);
          }
          break;
        case ErrorTypes.removingUserfromTeam:
          if (context.mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(removeuserFromTeamSnackbar);
          }
          break;
        case ErrorTypes.invalidTeamName:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(invalidteamnameSnackbar);
          }
          break;
        case ErrorTypes.teamCreation:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(teamcreationSnackbar);
          }
          break;
        case ErrorTypes.eventCreation:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(eventCreationSnackbar);
          }
          break;
        default:
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(unknownerrorSnackbar);
          }
          break;
      }
    });
  }
}
