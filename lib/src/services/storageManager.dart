import 'package:get_storage/get_storage.dart';

Future<void> deleteToken() async {
  final box = GetStorage();
  box.remove("token");
}

Future<void> saveToken(token) async {
  final box = GetStorage();
  box.write("token", token);
}

String getToken() {
  final box = GetStorage();
  String? token = box.read("token");
  if (token != null) {
    return token;
  } else {
    return "null";
  }
}
