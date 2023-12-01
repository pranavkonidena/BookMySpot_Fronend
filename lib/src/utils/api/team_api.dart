import 'package:book_my_spot_frontend/src/models/team.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/team/team_errors.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';

class TeamAPIEndpoint {
  TeamAPIEndpoint._();

  static fetchUserTeams() async {
    var token = getToken();
    Response response = await HttpHelper.makeRequest(
        RequestTypes.get, RequestGroup.other, "team?id=$token");
    if (response.statusCode == 200) {
      return response;
    } else {
      throw TeamException(ErrorTypes.fetchingTeams);
    }
  }

  static deleteTeam(Team team, String token) async {
    var postData = {
      "team_id": team.id.toString(),
      "id": token,
      "name": team.name
    };
    Response response = await HttpHelper.makeRequest(
        RequestTypes.delete, RequestGroup.team, "delete", postData);
    if (response.statusCode == 200) {
      return response;
    } else {
      if (response.statusCode == 403) {
        throw TeamException(ErrorTypes.notAdmin);
      } else {
        throw TeamException(ErrorTypes.deletingTeam);
      }
    }
  }

  static leaveTeam(Team team) async {
    String memberId = getToken();
    var postData = {
      "member_id": memberId,
      "team_id": team.id.toString(),
    };

    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.team, "leave", postData);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw UserException(ErrorTypes.leavingTeam, "Error while leaving team!");
    }
  }

  static removeMember(Team team, String removedUser) async {
    var postData = {
      "team_id": team.id.toString(),
      "id": getToken(),
      "member_id": removedUser,
    };
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.team, "remove", postData);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw TeamException(ErrorTypes.removingUserfromTeam);
    }
  }

  static createTeam(String teamName) async {
    if (teamName == "") {
      throw TeamException(ErrorTypes.invalidTeamName);
    }
    var postData = {"id": getToken(), "name": teamName};
    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.team, "create", postData);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw TeamException(ErrorTypes.teamCreation);
    }
  }
}
