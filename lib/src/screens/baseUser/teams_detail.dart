import 'dart:convert';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams_page.dart';
import 'package:book_my_spot_frontend/src/services/providers.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';
import '../../models/user.dart';

final _teamNameProvider = StateProvider<String>((ref) {
  return "";
});

final teamidChatProvider = StateProvider<int>((ref) {
  return 0;
});

bool isAdmin = false;
Map<String, String> adminDp = {};
Map<String, String> membersDp = {};
final teamdetailsProvider = FutureProvider<dynamic>((ref) async {
  final teamId = ref.read(teamIDProvider).toString();
  var response = await http.get(Uri.parse("${using}team/i?id=${teamId}"));
  var data = jsonDecode(response.body);
  ref.read(_teamNameProvider.notifier).state = data[0]["name"];
  for (int i = 0; i < data[0]["admin_id"].length; i++) {
    String id = data[0]["admin_id"][i];
    var profile_picResp = await http.get(Uri.parse(using + "user?id=$id"));
    var proData = jsonDecode(profile_picResp.body);
    if (!proData[0]["profile_pic"].contains("github")) {
      adminDp[proData[0]["id"]] =
          "https://channeli.in" + proData[0]["profile_pic"];
    } else {
      adminDp[proData[0]["id"]] = proData[0]["profile_pic"];
    }
    adminDp[proData[0]["id"] + "name"] = proData[0]["name"];
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
    membersDp[proData[0]["id"] + "name"] = proData[0]["name"];
    membersDp[proData[0]["id"]] = proData[0]["profile_pic"];
  }

  isAdmin = data[0]["admin_id"].contains(getToken());
  return data;
});

class TeamDetails extends ConsumerWidget {
  TeamDetails(this.id, {super.key});
  String? id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(teamdetailsProvider);
    return data.when(
      loading: () => const Center(child: const CircularProgressIndicator()),
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
                isAdmin
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: IconButton(
                            onPressed: () async {
                              User user = ref.watch(userProvider);
                              var post_data = {
                                "name": ref.watch(_teamNameProvider),
                                "id": user.token
                              };
                              print(post_data);
                              var response = await http.post(
                                  Uri.parse("${using}team/delete"),
                                  body: post_data);
                              ref.refresh(teamsListProvider);
                              context.go("/");
                            },
                            icon: Icon(
                              Icons.delete_forever_rounded,
                              color: Colors.grey[600],
                            )))
                    : SizedBox(),
                TextButton(
                    onPressed: () {
                      
                      context.go("/chat/${value[0]["id"]}");
                    },
                    child: Text("Chat"))
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text(
                        adminDp[value[0]["admin_id"][i].toString() + "name"]!,
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
                            adminDp[value[0]["admin_id"][i].toString()]!)),
                  ),
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
                    isAdmin
                        ? Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                                onPressed: () {
                                  context.go(
                                      "/grpcreate/teamDetails" + id.toString());
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            membersDp[
                                value[0]["members_id"][i].toString() + "name"]!,
                          ),
                          isAdmin
                              ? IconButton(
                                  onPressed: () async {
                                    var postData = {
                                      "name": ref.read(_teamNameProvider),
                                      "id": getToken(),
                                      "member_id":
                                          value[0]["members_id"][i].toString(),
                                    };
                                    var response = await http.post(
                                        Uri.parse("${using}team/remove"),
                                        body: postData);
                                    ref.refresh(teamdetailsProvider);
                                    // print(ref.watch(teamIDProvider));
                                  },
                                  icon: Icon(Icons.highlight_remove,
                                      color: Colors.grey.shade700))
                              : const SizedBox()
                        ],
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
                            membersDp[value[0]["members_id"][i].toString()]!)),
                  ),
                ),
            ]));
      },
    );
  }
}
