import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:http/http.dart' as http;

class User {
  late String token;
  String profilePic = "https://channeli.in";
  late String branchName;
  late String name;
  late int enrollNumber;
  fetchUserData() async {
    dynamic response =
        await http.get(Uri.parse(base_url_IITR_WIFI + "user?id=${token}"));
    dynamic data = jsonDecode(response.body.toString());
    return data;
  }

  userFromJSON() async {
    dynamic data = await fetchUserData();
    User u = User();
    u.branchName = data[0]["branch"];
    u.enrollNumber = data[0]["enroll_number"];
    u.name = data[0]["name"];
    u.profilePic = u.profilePic + data[0]["profile_pic"];
    return u;
  }
}
