import 'package:book_my_spot_frontend/src/screens/login.dart';
import 'package:go_router/go_router.dart';
import '../screens/home.dart';

final router = GoRouter(initialLocation: "/login", routes: [
  GoRoute(name: "home", path: "/", builder: (context, state) => const HomeScreen()),
  GoRoute(name: "login" , path: "/login" , builder: (context , state) => const LoginScreen())
]);
