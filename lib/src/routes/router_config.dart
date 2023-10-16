import 'package:book_my_spot_frontend/src/screens/login.dart';
import 'package:book_my_spot_frontend/src/screens/make_reservation.dart';
import 'package:book_my_spot_frontend/src/screens/profile_page.dart';
import 'package:book_my_spot_frontend/src/screens/teams_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home.dart';
import '../screens/login_webView.dart';

final router = GoRouter(routes: [
  GoRoute(
      name: "home", path: "/", builder: (context, state) => const HomeScreen()),
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
  GoRoute(path: "/new" , builder: (context, state) => const MakeReservationPage()),
  GoRoute(path: "/team" , builder: (context, state) => const TeamScreen()),
  GoRoute(path: "/profile" , builder: (context, state) => const ProfileScreen())
]);
