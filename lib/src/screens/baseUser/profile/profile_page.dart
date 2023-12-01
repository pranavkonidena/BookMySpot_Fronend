import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider);

    return Scaffold(
        body: Column(children: [
      const SizedBox(
        height: 40,
      ),
      Row(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(onPressed: (){context.go("/");}, icon: const Icon(Icons.arrow_back_ios)),
        )
      ],),
      Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.network(
            user!.profilePic,
            height: 100,
            width: 100,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(
        height: 10,
      ),
      Text(
        user.branchName,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        user.enrollNumber.toString(),
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(
        height: 50,
      ),
      ElevatedButton(
          onPressed: () async {
            UserAPIEndpoint.userLogout(context, ref);
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade400),
          child: const Text("Logout"))
    ]));
  }
}
