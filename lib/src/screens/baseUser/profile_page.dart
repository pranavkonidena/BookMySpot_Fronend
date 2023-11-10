import 'package:book_my_spot_frontend/src/utils/api/user_api.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userProvider);
    return Scaffold(
        body: Column(children: [
      const SizedBox(
        height: 40,
      ),
      Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.network(
            user.profilePic,
            height: 100,
            width: 100,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        user.name,
        style: TextStyle(fontSize: 26),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        user.branchName,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(user.enrollNumber.toString()),
      const SizedBox(
        height: 50,
      ),
      ElevatedButton(
          onPressed: () async {
            UserAPIEndpoint.userLogout(context, ref);
          },
          child: const Text("Logout"))
    ]));
  }
}
