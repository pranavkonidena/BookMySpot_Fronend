import 'package:book_my_spot_frontend/src/screens/login.dart';
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
]);
