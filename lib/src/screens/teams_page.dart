import 'dart:convert';
import 'package:book_my_spot_frontend/src/screens/teams_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:book_my_spot_frontend/src/screens/loading_screen.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';

final teamIDProvider = StateProvider<int>((ref) {
  return 0;
});

final teamsListProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse(using + "team?id=${getToken()}"));
  var data = jsonDecode(response.body);
  return data;
});

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(teamsListProvider);
    return data.when(
      loading: () => const LoadingScreen(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
      data: (value) {
        return Scaffold(
            body: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.only(top: 38.0, left: 16, right: 16),
          child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 20,
                );
              },
              shrinkWrap: true,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    ref.read(teamIDProvider.notifier).state =
                        value[index]["id"];
                    ref.refresh(teamdetailsProvider);
                    print("ID" + ref.read(teamIDProvider).toString());
                    context.go("/teamDetails${value[index]["id"]}");
                  },
                  tileColor: Color.fromRGBO(217, 217, 217, 0.3),
                  title: Center(
                      child: Text(
                    value[index]["name"],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontFamily: 'Thasadith',
                    ),
                  )),
                );
              }),
        )));
      },
    );
  }
}
