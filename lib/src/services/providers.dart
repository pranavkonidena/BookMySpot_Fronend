import 'package:book_my_spot_frontend/src/screens/baseUser/home.dart';
import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import './storageManager.dart';
import '../constants/constants.dart';
import 'dart:convert';




final groupidProvider = StateProvider<int>((ref) {
  return 0;
});

final dataIndexProvider = StateProvider<int>((ref) {
  return 0;
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