import 'package:book_my_spot_frontend/src/models/event.dart';
import 'package:book_my_spot_frontend/src/state/events/events_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ignore: must_be_immutable
class AmenityEventTeamsList extends ConsumerWidget {
  int id;
  AmenityEventTeamsList(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AmenityEvent? event =
        ref.watch(eventsProviderFinal.notifier).getEventDetails(id);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height / 12,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                context.go("/head");
              },
              icon: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Theme.of(context).iconTheme.color,
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
        body: event!.teams.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: SingleChildScrollView(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 30,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: event.teams.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () async {
                          await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Team Details"),
                                content: Column(
                                  children: [
                                    const Text("Admins"),
                                    for (int i = 0;
                                        i < event.teams[index].admins.length;
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.network(
                                                event.teams[index].admins[i]
                                                    .profilePic,
                                                height: 56,
                                                width: 56,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            event.teams[index].admins[i].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ],
                                      ),
                                    const Text("Members"),
                                    for (int i = 0;
                                        i < event.teams[index].members.length;
                                        i++)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Image.network(
                                                event.teams[index].members[i]
                                                    .profilePic,
                                                height: 56,
                                                width: 56,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            event.teams[index].members[i].name,
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
                                      child: const Text("Ok"))
                                ],
                              );
                            },
                          );
                        },
                        tileColor: const Color.fromRGBO(217, 217, 217, 0.3),
                        title: Center(
                            child: Text(
                          event.teams[index].name,
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
              )
            : const Center(child: Text("No teams registered!")));
  }
}
