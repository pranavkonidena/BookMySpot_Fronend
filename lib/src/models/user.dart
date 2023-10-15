import 'dart:convert';

import 'package:book_my_spot_frontend/src/constants/constants.dart';
import 'package:http/http.dart' as http;

class User {
  late String token;
  fetchUserData() async {
    dynamic response =
        await http.get(Uri.parse(base_url_IITR_WIFI + "user?id=${token}"));
    dynamic data = jsonDecode(response.body.toString());
    return data;
  }

  userFromJSON() {
    
  }
}
