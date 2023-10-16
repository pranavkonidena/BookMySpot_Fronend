import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './home.dart';
import 'package:go_router/go_router.dart';
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: ElevatedButton(
            onPressed: () {
              deleteToken();
              context.go("/login");
            },
            child: Text("Logout")),
      ),
    );
  }
}
