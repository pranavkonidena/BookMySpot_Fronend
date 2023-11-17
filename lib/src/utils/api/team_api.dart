import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/enums/error_types.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/errors/user/user_errors.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';

class TeamAPIEndpoint {
  TeamAPIEndpoint._();

  static leaveTeam(String teamName) async {
    String memberId = getToken();
    var postData = {
      "member_id": memberId,
      "name": teamName,
    };

    Response response = await HttpHelper.makeRequest(
        RequestTypes.post, RequestGroup.team, "leave", postData);

    if (response.statusCode == 200) {
      return response;
    } else {
      throw UserException(ErrorTypes.leavingTeam, "Error while leaving team!");
    }
  }
}
