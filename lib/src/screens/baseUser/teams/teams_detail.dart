import 'package:auto_size_text/auto_size_text.dart';
import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/screens/baseUser/teams/teams_page.dart';
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
  Team? team;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TeamDetailsState();
}

class _TeamDetailsState extends ConsumerState<TeamDetails> {
  @override
  void initState() {
    isAdmin = false;
    super.initState();
  }

  void didChangeDependencies() {
    widget.team =
        ref.watch(teamsProvider.notifier).getTeamDetails(int.parse(widget.id!));
    for (int i = 0; i < widget.team!.admins.length; i++) {
      if (widget.team!.admins[i].token ==
          StorageManager.getToken().toString()) {
        isAdmin = true;
        break;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                ref.refresh(teamIDProvider);
                context.go("/");
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).iconTheme.color
              )),
          title: Text(widget.team!.name,
              style: Theme.of(context).textTheme.headlineLarge),
          actions: [
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
                                  await TeamAPIEndpoint.leaveTeam(widget.team!);
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
                child: const Text("Leave" , style: TextStyle(color: Colors.black),)),
            TextButton(
                onPressed: () {
                  context.go("/chat/${widget.team!.id}");
                },
                child: const Text("Chat" , style: TextStyle(color: Colors.black),))
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
          for (int i = 0; i < widget.team!.admins.length; i++)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Row(
                    children: [
                      Text(widget.team!.admins[i].name),
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
                    child: Image.network(widget.team!.admins[i].profilePic)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          content: Text("Are you sure?"),
                          actions: [
                            ElevatedButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: const Text("No")),
                            ElevatedButton(
                                onPressed: () async {
                                  User? user = ref.watch(userProvider);
                                  try {
                                    await TeamAPIEndpoint.deleteTeam(
                                        widget.team!, user!.token);
                                    if (context.mounted) {
                                      context.go("/");
                                    }
                                  } on TeamException catch (e) {
                                    e.handleError(ref);
                                  }
                                },
                                child: const Text("Yes"))
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      side: const BorderSide(width: 2, color: Colors.red),
                      backgroundColor: Colors.white10),
                  child: Text("Delete this team",
                      style: Theme.of(context).textTheme.labelLarge),
                )),
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
                              color: Theme.of(context).iconTheme.color
                            )),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          for (int i = 0; i < widget.team!.members.length; i++)
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
                          widget.team!.members[i].name,
                        ),
                      ),
                      isAdmin
                          ? IconButton(
                              onPressed: () async {
                                try {
                                  await TeamAPIEndpoint.removeMember(
                                      widget.team!,
                                      widget.team!.members[i].token);
                                  widget.team!.members
                                      .remove(widget.team!.members[i]);
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
                  child: Image.network(widget.team!.members[i].profilePic),
                ),
              ),
            )
        ]));
  }
}
