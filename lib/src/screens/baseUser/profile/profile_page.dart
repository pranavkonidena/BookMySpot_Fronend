import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        leading: IconButton(onPressed: (){context.go("/");}, icon: Icon(Icons.arrow_back_ios , color: Theme.of(context).iconTheme.color,)),
        title: Text(
          "Profile",
          style: GoogleFonts.openSans(),
        )),
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
