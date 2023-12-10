import 'dart:convert';
import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:http/http.dart' as http;

class User {
  late String token;
  late String branchName;
  late String name;
  late int enrollNumber;
  late String profilePic;

  User(String tokenGiven) {
    token = tokenGiven;
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    dynamic response = await http.get(Uri.parse("${using}user?id=$token"));
    var data = jsonDecode(response.body.toString());
    data = data[0];
    return data;
  }

  Future<User> userFromJSON() async {
    dynamic data = await _fetchUserData();
    User u = User(token);
    u.branchName = data["branch"];
    u.enrollNumber = data["enroll_number"];
    u.name = data["name"];
    u.profilePic = data["profile_pic"].contains("github")
        ? data["profile_pic"]
        : "https://channeli.in${data["profile_pic"]}";
    return u;
  }
}
