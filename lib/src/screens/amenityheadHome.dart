import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AmenityHeadHome extends ConsumerWidget {
  const AmenityHeadHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String admintoken = getAdminToken();
    if (admintoken == "null") {
      context.go("/login");
    }
    return Scaffold(
      body: Column(
        children: [
          Center(child: Text("Amenity head ")),
          ElevatedButton(
              onPressed: () {
                deleteAdminToken();
                context.go("/login");
              },
              child: Text("Log out"))
        ],
      ),
    );
  }
}
