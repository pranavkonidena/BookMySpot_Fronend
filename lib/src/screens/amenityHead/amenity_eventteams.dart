import 'dart:convert';
import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/screens/amenityHead/events_list.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_detail.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/state/teams/team_state.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../constants/constants.dart';

final _allTeamsInEventProvider = FutureProvider<List<dynamic>>((ref) async {
  List<dynamic> teams = ref.watch(selectedEventIDProvider);
  List<dynamic> teamDetails = [];
  for (int i = 0; i < teams.length; i++) {
    var response = await http.get(Uri.parse("${using}team/i?id=${teams[i]}"));
    print(response.statusCode);
    var data = jsonDecode(response.body.toString());
    teamDetails.add(data);
  }

  return teamDetails;
});

class AmenityEventTeamsList extends ConsumerWidget {
  const AmenityEventTeamsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teams_details = ref.watch(_allTeamsInEventProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        elevation: 0,
        backgroundColor: const Color.fromARGB(168, 35, 187, 233),
        leading: IconButton(
            onPressed: () {
              context.go("/head");
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.grey[700],
            )),
        title: const Text(
          "Registered Teams",
          style: TextStyle(
            color: Colors.black,
            fontSize: 40,
            fontFamily: 'Thasadith',
          ),
        ),
      ),
      body: teams_details.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return const SizedBox();
        },
        data: (data) {
          return Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: SingleChildScrollView(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    height: 30,
                  );
                },
                shrinkWrap: true,
                itemCount: data.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      var id = data[index][0]["id"];
                      var team_data =
                          await http.get(Uri.parse(using + "team/i?id=$id"));
                      List<User> members = [];
                      List<User> admins = [];
                      var data_jsondecoded =
                          jsonDecode(team_data.body.toString());
                      for (int i = 0;
                          i < data_jsondecoded[0]["members_id"].length;
                          i++) {
                        User user = User(data_jsondecoded[0]["members_id"][i]);
                        user = await user.userFromJSON();
                        members.add(user);
                      }
                      for (int i = 0;
                          i < data_jsondecoded[0]["admin_id"].length;
                          i++) {
                        User user = User(data_jsondecoded[0]["admin_id"][i]);
                        user = await user.userFromJSON();
                        admins.add(user);
                      }
                      print(admins[0].profilePic);
                      await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Team Details"),
                            content: Column(
                              children: [
                                Text("Admins"),
                                for (int i = 0; i < admins.length; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            admins[i].profilePic,
                                            height: 56,
                                            width: 56,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        admins[i].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  ),
                                Text("Members"),
                                for (int i = 0; i < members.length; i++)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Image.network(
                                            members[i].profilePic,
                                            height: 56,
                                            width: 56,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        members[i].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: Text("Ok"))
                            ],
                          );
                        },
                      );
                      print(members.length);
                      print(admins.length);
                      print(admins[0].name);
                    },
                    tileColor: Color.fromRGBO(217, 217, 217, 0.3),
                    title: Center(
                        child: Text(
                      data[index][0]["name"],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 35,
                        fontFamily: 'Thasadith',
                      ),
                    )),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
