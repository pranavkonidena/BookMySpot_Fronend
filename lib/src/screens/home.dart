import 'package:book_my_spot_frontend/src/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import '../services/storageManager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String token = getToken();
    if (token == "null") {
      return LoginScreen();
    } else {
      return Scaffold(
        backgroundColor: Colors.red,
        body: Column(children: [
          Text("HEY"),
          SizedBox(height: 30,),
          ElevatedButton(
              onPressed: () {
                context.go("/login");
                deleteToken();
              },
              child: Text(token))
        ]),
      );
    }
    
  }
}
