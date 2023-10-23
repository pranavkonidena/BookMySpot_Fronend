import 'dart:convert';

import 'package:book_my_spot_frontend/src/screens/teams_page.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

bool is_admin = false;

final teamdetailsProvider = FutureProvider<dynamic>((ref) async {
  final team_id = ref.read(teamIDProvider).toString();
  var response = await http.get(Uri.parse(using + "team/i?id=${team_id}"));
  var data = jsonDecode(response.body);

  is_admin = data[0]["admin_id"].contains(getToken());
  return data;
});

class TeamDetails extends ConsumerWidget {
  const TeamDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(teamdetailsProvider);
    return data.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
      data: (value) {
        print("YAY");
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 12,
              elevation: 0,
              backgroundColor: const Color.fromARGB(168, 35, 187, 233),
              leading: IconButton(
                  onPressed: () {
                    context.go("/");
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[700],
                  )),
              title: Text(
                value[0]["name"],
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                  fontFamily: 'Thasadith',
                ),
              ),
              actions: [
                is_admin
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add,
                              color: Colors.grey[700],
                            )))
                    : SizedBox()
              ],
            ),
            body: Center(
              child: Text(is_admin.toString()),
            ));
      },
    );
  }
}
