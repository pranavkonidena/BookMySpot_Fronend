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
Map<String, String> admin_dp = {};
Map<String, String> members_dp = {};
final teamdetailsProvider = FutureProvider<dynamic>((ref) async {
  final team_id = ref.read(teamIDProvider).toString();
  var response = await http.get(Uri.parse(using + "team/i?id=${team_id}"));
  var data = jsonDecode(response.body);
  for (int i = 0; i < data[0]["admin_id"].length; i++) {
    String id = data[0]["admin_id"][i];
    var profile_picResp = await http.get(Uri.parse(using + "user?id=$id"));
    var proData = jsonDecode(profile_picResp.body);
    if (!proData[0]["profile_pic"].contains("github")) {
      admin_dp[proData[0]["id"]] =
          "https://channeli.in" + proData[0]["profile_pic"];
    } else {
      admin_dp[proData[0]["id"]] = proData[0]["profile_pic"];
    }
    admin_dp[proData[0]["id"] + "name"] = proData[0]["name"];
  }
  for (int i = 0; i < data[0]["members_id"].length; i++) {
    String id = data[0]["members_id"][i];
    var profile_picResp = await http.get(Uri.parse(using + "user?id=$id"));
    var proData = jsonDecode(profile_picResp.body);
    if (proData[0]["profile_pic"].contains("github")) {
    } else {
      proData[0]["profile_pic"] =
          "https://channeli.in" + proData[0]["profile_pic"];
    }
    members_dp[proData[0]["id"] + "name"] = proData[0]["name"];
    members_dp[proData[0]["id"]] = proData[0]["profile_pic"];
  }

  is_admin = data[0]["admin_id"].contains(getToken());
  return data;
});

class TeamDetails extends ConsumerWidget {
  TeamDetails(this.id, {super.key});
  String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(teamdetailsProvider);
    return data.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stackTrace) {
        return const SizedBox();
      },
      data: (value) {
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 12,
              elevation: 0,
              backgroundColor: const Color.fromARGB(168, 35, 187, 233),
              leading: IconButton(
                  onPressed: () {
                    ref.refresh(teamdetailsProvider);
                    ref.refresh(teamIDProvider);
                    context.go("/");
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.grey[700],
                  )),
              title: Text(
                value[0]["name"],
                style: const TextStyle(
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
                            onPressed: () async {
                              String name = value[0]["name"];
                              String id = getToken();
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.grey[700],
                            )))
                    : SizedBox()
              ],
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 18),
                child: Row(
                  children: [
                    Text(
                      "Admins",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Thasadith',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              for (int i = 0; i < value[0]["admin_id"].length; i++)
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      admin_dp[value[0]["admin_id"][i].toString() + "name"]!,
                    ),
                  ),
                  leading: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 56,
                      width: 56,
                      child: Image.network(
                          admin_dp[value[0]["admin_id"][i].toString()]!)),
                ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, top: 18),
                child: Row(
                  children: [
                    Text(
                      "Members",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontFamily: 'Thasadith',
                      ),
                    ),
                    is_admin
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                                onPressed: () {
                                  context.go("/grpcreate/teamDetails" + id.toString());
                                },
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.grey[700],
                                )),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              for (int i = 0; i < value[0]["members_id"].length; i++)
                ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Text(
                      members_dp[
                          value[0]["members_id"][i].toString() + "name"]!,
                    ),
                  ),
                  leading: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      height: 56,
                      width: 56,
                      child: Image.network(
                          members_dp[value[0]["members_id"][i].toString()]!)),
                ),
            ]));
      },
    );
  }
}
