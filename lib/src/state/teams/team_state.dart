import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/utils/api/team_api.dart';
import 'package:book_my_spot_frontend/src/utils/errors/team/team_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamNotifier extends StateNotifier<List<Team>> {
  TeamNotifier() : super([]);

  Future<List<Team>?> getTeams(WidgetRef ref) async {
    try {
      Response response = await TeamAPIEndpoint.fetchUserTeams();
      List<Team> userTeams = [];
      for (int i = 0; i < response.data.length; i++) {
        Team team = Team();
        team.id = response.data[i]["id"];
        team.name = response.data[i]["name"];
        List<User> members = [];
        List<User> admins = [];
        for (int j = 0; j < response.data[i]["members_id"].length; j++) {
          String uid = response.data[i]["members_id"][j];
          User user = User(uid);
          user = await user.userFromJSON();
          members.add(user);
        }
        for (int j = 0; j < response.data[i]["admin_id"].length; j++) {
          String uid = response.data[i]["admin_id"][j];
          User user = User(uid);
          user = await user.userFromJSON();
          admins.add(user);
        }
        team.members = members;
        team.admins = admins;
        userTeams.add(team);
      }
      state = userTeams;
      return userTeams;
    } on TeamException catch (e) {
      e.handleError(ref);
    }
  }

  Future<Team?> fetchTeamFromServer(int teamId, WidgetRef ref) async {
    try {
      Response response = await TeamAPIEndpoint.fetchTeamFromServer(teamId);
      Team team = Team();
      team.id = response.data[0]["id"];
      team.name = response.data[0]["name"];
      List<User> members = [];
      List<User> admins = [];
      for (int j = 0; j < response.data[0]["members_id"].length; j++) {
        String uid = response.data[0]["members_id"][j];
        User user = User(uid);
        user = await user.userFromJSON();
        members.add(user);
      }
      for (int j = 0; j < response.data[0]["admin_id"].length; j++) {
        String uid = response.data[0]["admin_id"][j];
        User user = User(uid);
        user = await user.userFromJSON();
        admins.add(user);
      }
      team.members = members;
      team.admins = admins;
      return team;
    } on TeamException catch (e) {
      e.handleError(ref);
      return null;
    }
  }

  Team? getTeamDetails(int id) {
    for (Team team in state) {
      if (team.id == id) {
        return team;
      }
    }
    return null;
  }

  Future<void> addMember(String uid, int teamId) async {
    List<Team> teams = [];
    for (Team team in state) {
      if (team.id == teamId) {
        User user = User(uid);
        user = await user.userFromJSON();
        print(team.members.length);
        team.members.add(user);
        print(team.members.length);
        teams.add(team);
      } else {
        teams.add(team);
      }
    }
    state = teams;
  }
}

final teamsProvider = StateNotifierProvider<TeamNotifier, List<Team>>((ref) {
  return TeamNotifier();
});
