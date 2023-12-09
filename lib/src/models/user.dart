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
  
  _fetchUserData() async {
    print("FETCH CALLED");
    dynamic response = await http.get(Uri.parse(using + "user?id=${token}"));
    dynamic data = jsonDecode(response.body.toString());
    return data;
  }

  Future<User> userFromJSON() async {
    dynamic data = await _fetchUserData();
    User u = User(token);
    u.branchName = data[0]["branch"];
    u.enrollNumber = data[0]["enroll_number"];
    u.name = data[0]["name"];
    u.profilePic = data[0]["profile_pic"].contains("github")
        ? data[0]["profile_pic"]
        : "https://channeli.in" + data[0]["profile_pic"];
    return u;
  }
}
