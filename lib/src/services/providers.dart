import 'package:book_my_spot_frontend/src/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import './storageManager.dart';
import '../models/date.dart';
import '../constants/constants.dart';
import 'dart:convert';

final userFutureProvider = FutureProvider<User>((ref) async {
  User u = User(getToken());
  return await u.userFromJSON();
});

final userProvider = StateProvider<User>((ref) {
  return User(getToken());
});


final groupidProvider = StateProvider<int>((ref) {
  return 0;
});

final dataIndexProvider = StateProvider<int>((ref) {
  return 0;
});

final calendarStateProvider = StateProvider<bool>((ref) {
  return false;
});





final userBookingsProvider = FutureProvider<dynamic>((ref) async {
  User user = ref.watch(userProvider);
  String token = user.token;
  final date = ref.watch(focusedProvider);
  var postBody = {
    "id": token,
    "date": "${date.year}-${date.month}-${date.day}"
  };
  dynamic response =
      await http.post(Uri.parse("${using}user/getBooking"), body: postBody);
  dynamic data = jsonDecode(response.body);

  for (int i = 0; i < data.length; i++) {
    try {
      data[i] = jsonDecode(data[i].toString());
    } catch (e) {
      print(e);
    }
    data[i]["time_of_slot"] = DateTime.parse(data[i]["time_of_slot"]);
    data[i]["end_time"] = data[i]["time_of_slot"]
        .add(Duration(minutes: data[i]["duration_of_booking"]));
  }
  return data;
});

final uriProvider = StateProvider<Uri>((ref) {
  return Uri.parse("channeli");
});

final initialdataProvider = FutureProvider<String>((ref) async {
  Uri uri = ref.watch(uriProvider);
  if (!uri.toString().contains("channeli")) {
    var response = await http.get(uri);
    print(response.statusCode);
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body).toString();
      return token;
    } else {
      return "failed";
    }
  } else {
    return "not done";
  }
});

final finalTeamsProvider = StateProvider<dynamic>((ref) {
  return;
});

final selectedEventProvider = StateProvider<int>((ref) {
  return 0;
});