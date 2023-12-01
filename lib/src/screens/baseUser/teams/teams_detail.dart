import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
import 'package:book_my_spot_frontend/src/screens/splash/splash_screen.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/state/teams/team_state.dart';
import 'package:book_my_spot_frontend/src/state/user/user_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/team_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/team/team_errors.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user.dart';

final teamidChatProvider = StateProvider<int>((ref) {
  return 0;
});

bool isAdmin = false;

class TeamDetails extends ConsumerStatefulWidget {
  TeamDetails(this.id, {super.key});
  String? id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends ConsumerState<TeamDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Team? team =
        ref.watch(teamsProvider.notifier).getTeamDetails(int.parse(widget.id!));
    print("DATA FETCHED!");
    for (int i = 0; i < team!.admins.length; i++) {
      if (team.admins[i].token == getToken()) {
        isAdmin = true;
        break;
      }
    }
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          backgroundColor: const Color.fromARGB(168, 35, 187, 233),
          leading: IconButton(
              onPressed: () {
                ref.refresh(teamIDProvider);
                context.go("/");
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[700],
              )),
          title:
              Text(team.name, style: Theme.of(context).textTheme.headlineLarge),
          actions: [
            isAdmin
                ? Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                        onPressed: () async {
                          User? user = ref.watch(userProvider);
                          try {
                            await TeamAPIEndpoint.deleteTeam(team, user!.token);
                            if (context.mounted) {
                              context.go("/");
                            }
                          } on TeamException catch (e) {
                            e.handleError(ref);
                          }
                        },
                        icon: Icon(
                          Icons.delete_forever_rounded,
                          color: Colors.grey[600],
                        )))
                : const SizedBox(),
            TextButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog.adaptive(
                        content: const Text("Do you want to leave the team?"),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                context.pop();
                              },
                              child: const Text("No")),
                          ElevatedButton(
                              onPressed: () async {
                                try {
                                  await TeamAPIEndpoint.leaveTeam(team);
                                  if (context.mounted) {
                                    context.go("/");
                                  }
                                } on UserException catch (e) {
                                  if (context.mounted) {
                                    context.pop();
                                  }
                                  e.errorHandler(ref);
                                } catch (e) {
                                  print(
                                      "Unknown error occoured!" + e.toString());
                                }
                              },
                              child: const Text("Yes"))
                        ],
                      );
                    },
                  );
                },
                child: const Text("Leave")),
            TextButton(
                onPressed: () {
                  context.go("/chat/${team.id}");
                },
                child: const Text("Chat"))
          ],
        ),
        body: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 18),
            child: Row(
              children: [
                Text("Admins",
                    style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          for (int i = 0; i < team.admins.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(team.admins[i].name),
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
                    child: Image.network(team.admins[i].profilePic)),
              ),
            ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 18),
            child: Row(
              children: [
                Text("Members",
                    style: Theme.of(context).textTheme.headlineMedium),
                isAdmin
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: IconButton(
                            onPressed: () {
                              if (context.mounted) {
                                context
                                    .go("/grpcreate/teamDetails${widget.id}");
                              }
                              setState(() {});
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
          const SizedBox(
            height: 10,
          ),
          for (int i = 0; i < team.members.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          team.members[i].name,
                        ),
                      ),
                      isAdmin
                          ? IconButton(
                              onPressed: () async {
                                try {
                                  await TeamAPIEndpoint.removeMember(
                                      team, team.members[i].token);
                                  team.members.remove(team.members[i]);
                                  setState(() {});
                                } on TeamException catch (e) {
                                  e.handleError(ref);
                                }
                              },
                              icon: Icon(Icons.highlight_remove,
                                  color: Theme.of(context).iconTheme.color))
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
                  child: Image.network(team.members[i].profilePic),
                ),
              ),
            )
        ]));
  }
}
