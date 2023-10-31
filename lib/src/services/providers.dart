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


final selectedProvider = StateProvider<DateTime?>((ref) {
  DateTime? _selectedDay;
  return _selectedDay;
});

final focusedProvider = StateProvider<DateTime>((ref) {
  DateTime _focusedDay = DateTime.now();
  return _focusedDay;
});

final dateProvider = Provider<Date>((ref) {
  final now = ref.watch(focusedProvider);
  String year = "";
  year += "${now.year % 100}";

  Date _date = Date();
  _date.date = "${now.day}th ${months[now.month]} '$year";
  _date.day = days[now.weekday];
  return _date;
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



final finalTeamsProvider = StateProvider<dynamic>((ref) {
  return;
});

final selectedEventProvider = StateProvider<int>((ref) {
  return 0;
});