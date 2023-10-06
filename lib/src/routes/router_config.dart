import 'dart:js';

import 'package:go_router/go_router.dart';
import '../screens/home.dart';

final router = GoRouter(initialLocation: "/", routes: [
  GoRoute(name: "home", path: "/", builder: (context, state) => HomeScreen())
]);
