import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/state/teams/team_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final teamIDProvider = StateProvider<int>((ref) {
  return 0;
});

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<List<Team>?> teams = ref.watch(teamsProvider.notifier).getTeams(ref);
    return FutureBuilder(
      future: teams,
      builder: (context, userTeams) {
        if (userTeams.hasData) {
          List<Team>? userTeamsList = userTeams.data;
          if (userTeamsList != null) {
            if (userTeamsList.isNotEmpty) {
              return Scaffold(
                  body: SingleChildScrollView(
                      child: Padding(
                padding: const EdgeInsets.only(top: 38.0, left: 16, right: 16),
                child: ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                    shrinkWrap: true,
                    itemCount: userTeamsList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          ref.read(teamIDProvider.notifier).state =
                              userTeamsList[index].id;
                          context.go("/teamDetails${userTeamsList[index].id}");
                        },
                        tileColor: const Color.fromRGBO(217, 217, 217, 0.3),
                        title: Center(
                            child: Text(
                          userTeamsList[index].name,
                          style: Theme.of(context).textTheme.bodyLarge
                        )),
                      );
                    }),
              )));
            } else {
              return Center(
                child: Text("You are not a part of any team :(",
                    style: Theme.of(context).textTheme.bodyMedium),
              );
            }
          } else {
            return const SizedBox();
          }
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }
}
