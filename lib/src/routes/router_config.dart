import 'package:book_my_spot_frontend/src/screens/amenityheadHome.dart';
import 'package:book_my_spot_frontend/src/screens/checkSlots.dart';
import 'package:book_my_spot_frontend/src/screens/confirm_booking.dart';
import 'package:book_my_spot_frontend/src/screens/individualBookingDetails.dart';
import 'package:book_my_spot_frontend/src/screens/login.dart';
import 'package:book_my_spot_frontend/src/screens/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/login_webView.dart';

final router = GoRouter(routes: [
  GoRoute(name: "home", path: "/", builder: (context, state) => HomeScreen()),
  GoRoute(
      name: "login",
      path: "/login",
      builder: (context, state) {
        return LoginScreen();
      }),
  GoRoute(
      name: "webview",
      path: "/webview",
      builder: (context, state) => const WebViewLogin()),
  GoRoute(
      name: "loading",
      path: "/loading",
      builder: (context, state) => const WebViewLogin()),
  GoRoute(
      path: "/new", builder: (context, state) => const MakeReservationPage()),
  GoRoute(path: "/team", builder: (context, state) => const TeamScreen()),
  GoRoute(path: "/profile", builder: (context, state) => const ProfileScreen()),
  GoRoute(
    path: "/new/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return ConfirmBooking(id);
    },
  ),
  GoRoute(
    path: "/checkSlots",
    builder: (context, state) {
      return BookingPageFinal();
    },
  ),
  GoRoute(
    path: "/booking/individual/:id",
    builder: (context, state) {
      final id = state.pathParameters["id"];
      return IndividualBookingDetails(id.toString());
    },
  ),
  GoRoute(
    path: "/head",
    builder: (context, state) {
      return AmenityHeadHome();
    },
  )
]);
