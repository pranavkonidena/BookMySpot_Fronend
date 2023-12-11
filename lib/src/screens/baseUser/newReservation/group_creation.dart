// ignore_for_file: unused_result

import 'dart:convert';
import 'package:book_my_spot_frontend/src/state/teams/team_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/team_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/team/team_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/services/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

final groupselectedProvider = StateProvider<List<Map>>((ref) {
  List<Map> l = [];
  return l;
});

final currentStringProvider = StateProvider<String>((ref) {
  return "";
});

final filtereditemsProvider = StateProvider<List<Map>>((ref) {
  return ref.read(itemsProvider);
});

final itemsProvider = StateProvider<List<Map>>((ref) {
  List<Map> l = [];
  return l;
});

final usersAllProvider = FutureProvider<dynamic>((ref) async {
  var response = await http.get(Uri.parse("${using}user"));
  var data = jsonDecode(response.body.toString());
  for (int i = 0; i < data.length; i++) {
    var entry = {};
    entry["name"] = data[i]["name"];
    entry["dp"] = data[i]["profile_pic"];
    entry["id"] = data[i]["id"];
    if (entry["id"] != StorageManager.getToken().toString()) {
      ref.read(itemsProvider.notifier).state.add(entry);
    }
  }

  return data;
});

// ignore: must_be_immutable
class GroupCreatePage extends ConsumerStatefulWidget {
  GroupCreatePage(this.fallbackRoute, {super.key});
  String fallbackRoute;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GroupCreatePageState();
}

class _GroupCreatePageState extends ConsumerState<GroupCreatePage> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(usersAllProvider);
    return data.when(
      data: (data) {
        return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height / 12,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    ref.refresh(currentStringProvider);
                    ref.refresh(filtereditemsProvider);
                    ref.refresh(groupselectedProvider);
                    context.go(widget.fallbackRoute);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).iconTheme.color,
                  )),
              title: const Text(
                "Add Participants",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontFamily: 'Thasadith',
                  fontWeight: FontWeight.w400,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: TextButton(
                      onPressed: () async {
                        if (widget.fallbackRoute.contains('/checkSlots')) {
                          SnackBar snackBarNew = const SnackBar(
                              content:
                                  Text("Group must have atleast 2 members"));
                          if (ref
                                  .read(groupselectedProvider.notifier)
                                  .state
                                  .length <
                              2) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBarNew);
                          } else {
                            context.go("/grpbooking");
                          }
                        } else if (widget.fallbackRoute
                            .contains("teamDetails")) {
                          var id = ref.watch(teamIDProvider);
                          var response = await http
                              .get(Uri.parse("${using}team/i?id=$id"));
                          var data = jsonDecode(response.body.toString());
                          var teamName = data[0]["name"];
                          var teamId = data[0]["id"];
                          for (int i = 0;
                              i <
                                  ref
                                      .watch(groupselectedProvider.notifier)
                                      .state
                                      .length;
                              i++) {
                            var entry = ref.watch(groupselectedProvider)[i];
                            var memberId = entry["id"];
                            var admin = entry["admin"];

                            var postData = {
                              "id": StorageManager.getToken().toString(),
                              "name": teamName,
                              "member_id": memberId,
                              "admin": admin,
                              "team_id": teamId.toString()
                            };

                            var response = await http.post(
                                Uri.parse("${using}team/add"),
                                body: postData);
                            var data = jsonDecode(response.body.toString());
                            debugPrint(data);
                          }
                          ref.refresh(groupselectedProvider);
                          await ref.watch(teamsProvider.notifier).getTeams(ref);
                          Future.microtask(() => context.go("/teamDetails$id"));
                        } else if (widget.fallbackRoute.contains("/home")) {
                          TextEditingController textFieldController =
                              TextEditingController();
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Enter Team Name'),
                                content: TextField(
                                  controller: textFieldController,
                                  decoration: const InputDecoration(
                                      hintText: "Team name here"),
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () async {
                                      try {
                                        Response response =
                                            await TeamAPIEndpoint.createTeam(
                                                textFieldController.text);
                                        try {
                                          if (ref
                                              .read(groupselectedProvider)
                                              .isNotEmpty) {
                                            if (response.statusCode == 200) {
                                              for (int i = 0;
                                                  i <
                                                      ref
                                                          .watch(
                                                              groupselectedProvider)
                                                          .length;
                                                  i++) {
                                                var entry = ref.watch(
                                                    groupselectedProvider)[i];
                                                var memberId = entry["id"];
                                                var admin = entry["admin"];

                                                var postData = {
                                                  "id":
                                                      StorageManager.getToken()
                                                          .toString(),
                                                  "team_id":
                                                      response.data.toString(),
                                                  "name":
                                                      textFieldController.text,
                                                  "member_id": memberId,
                                                  "admin": admin,
                                                };
                                                debugPrint(postData.toString());
                                                await http.post(
                                                    Uri.parse(
                                                        "${using}team/add"),
                                                    body: postData);
                                              }
                                              Future.microtask(
                                                  () => context.go("/"));
                                              if (context.mounted) {
                                                Navigator.pop(context);
                                              }
                                            } else {
                                              SnackBar snackBar = const SnackBar(
                                                  content: Text(
                                                      "Error occoured while creating team!"));
                                              if (context.mounted) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                          } else {
                                            SnackBar snackBar = const SnackBar(
                                                content: Text(
                                                    "Please selct atleast one member before proceeding!"));
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        } catch (e) {
                                          debugPrint(e.toString());
                                        }
                                      } on TeamException catch (e) {
                                        e.handleError(ref);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontFamily: 'Thasadith',
                          fontWeight: FontWeight.w400,
                          height: 0.05,
                        ),
                      )),
                )
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: "Search name",
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      var allPlayers = ref.read(itemsProvider);
                      List<Map> filteredPlayers = [];

                      if (value.isEmpty) {
                        filteredPlayers = allPlayers;
                      } else {
                        filteredPlayers = allPlayers
                            .where((element) => element["name"]
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      }
                      ref.read(filtereditemsProvider.notifier).state =
                          filteredPlayers;
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                    visible: ref
                        .watch(groupselectedProvider.notifier)
                        .state
                        .isNotEmpty,
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        for (int i = 0;
                            i <
                                ref
                                    .read(groupselectedProvider.notifier)
                                    .state
                                    .length;
                            i++)
                          ref
                                  .read(groupselectedProvider.notifier)
                                  .state[i]["dp"]
                                  .contains("github")
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Image.network(
                                        ref
                                            .read(
                                                groupselectedProvider.notifier)
                                            .state[i]["dp"],
                                        height: 56,
                                        width: 56,
                                      ),
                                      Text(
                                        ref.read(groupselectedProvider)[i]
                                            ["name"],
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "https://channeli.in" +
                                              ref
                                                  .read(groupselectedProvider
                                                      .notifier)
                                                  .state[i]["dp"],
                                          height: 56,
                                          width: 56,
                                        ),
                                      ),
                                      Text(
                                        ref.read(groupselectedProvider)[i]
                                            ["name"],
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                )
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: ref.watch(filtereditemsProvider).length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              if (widget.fallbackRoute.contains("checkSlots")) {
                                var entry = {};
                                entry["name"] = ref
                                    .read(filtereditemsProvider)[index]["name"];
                                entry["dp"] = ref
                                    .read(filtereditemsProvider)[index]["dp"];
                                entry["id"] = ref
                                    .read(filtereditemsProvider.notifier)
                                    .state[index]["id"];
                                bool isNamePresent = ref
                                    .read(groupselectedProvider)
                                    .any((map) => map['name'] == entry["name"]);
                                if (isNamePresent) {
                                  ref
                                      .read(groupselectedProvider.notifier)
                                      .state
                                      .removeWhere((map) =>
                                          map["name"] == entry["name"]);
                                } else {
                                  ref
                                      .read(groupselectedProvider.notifier)
                                      .state
                                      .add(entry);
                                }
                                setState(() {});
                              } else if (widget.fallbackRoute
                                      .contains("teamDetails") ||
                                  widget.fallbackRoute.contains("home")) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Visibility(
                                      visible: true,
                                      child: Dialog(
                                        child: SizedBox(
                                            height: 100,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text("Select Role"),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          var entry = {};
                                                          entry[
                                                              "name"] = ref.read(
                                                                  filtereditemsProvider)[
                                                              index]["name"];
                                                          entry[
                                                              "dp"] = ref.read(
                                                                  filtereditemsProvider)[
                                                              index]["dp"];
                                                          entry["id"] = ref
                                                              .read(
                                                                  filtereditemsProvider
                                                                      .notifier)
                                                              .state[index]["id"];
                                                          entry["admin"] =
                                                              "True";
                                                          bool isNamePresent = ref
                                                              .read(
                                                                  groupselectedProvider)
                                                              .any((map) =>
                                                                  map['name'] ==
                                                                  entry[
                                                                      "name"]);
                                                          if (isNamePresent) {
                                                            ref
                                                                .read(groupselectedProvider
                                                                    .notifier)
                                                                .state
                                                                .removeWhere((map) =>
                                                                    map["name"] ==
                                                                    entry[
                                                                        "name"]);
                                                          } else {
                                                            ref
                                                                .read(groupselectedProvider
                                                                    .notifier)
                                                                .state
                                                                .add(entry);
                                                          }

                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {});
                                                        },
                                                        child: const Text(
                                                            "Admin")),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          var entry = {};
                                                          entry[
                                                              "name"] = ref.read(
                                                                  filtereditemsProvider)[
                                                              index]["name"];
                                                          entry[
                                                              "dp"] = ref.read(
                                                                  filtereditemsProvider)[
                                                              index]["dp"];
                                                          entry["id"] = ref
                                                              .read(
                                                                  filtereditemsProvider
                                                                      .notifier)
                                                              .state[index]["id"];
                                                          entry["admin"] =
                                                              "False";
                                                          bool isNamePresent = ref
                                                              .read(
                                                                  groupselectedProvider)
                                                              .any((map) =>
                                                                  map['name'] ==
                                                                  entry[
                                                                      "name"]);
                                                          if (isNamePresent) {
                                                            ref
                                                                .read(groupselectedProvider
                                                                    .notifier)
                                                                .state
                                                                .removeWhere((map) =>
                                                                    map["name"] ==
                                                                    entry[
                                                                        "name"]);
                                                          } else {
                                                            ref
                                                                .read(groupselectedProvider
                                                                    .notifier)
                                                                .state
                                                                .add(entry);
                                                          }

                                                          setState(() {});
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            "Member"))
                                                  ],
                                                )
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ref
                                        .watch(filtereditemsProvider)[index]
                                            ["dp"]
                                        .contains("github")
                                    ? Image.network(
                                        ref.watch(filtereditemsProvider)[index]
                                            ["dp"],
                                        height: 56,
                                        width: 56,
                                      )
                                    : Container(
                                        width: 56,
                                        height: 56,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          // ignore: prefer_interpolation_to_compose_strings
                                          "https://channeli.in" +
                                              ref.watch(filtereditemsProvider)[
                                                  index]["dp"],
                                        ),
                                      ),
                              ],
                            ),
                            title: Row(
                              children: [
                                Text(
                                  ref.watch(filtereditemsProvider)[index]
                                      ["name"],
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ))
              ],
            ));
      },
      error: (error, stackTrace) {
        return const SizedBox();
      },
      loading: () {
        return const SpinKitFadingCircle(
          color: Color(0xff0E6BA8),
          size: 50.0,
        );
      },
    );
  }
}
