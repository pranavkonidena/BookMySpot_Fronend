import 'package:get_storage/get_storage.dart';

class StorageManager {
  StorageManager._();

  static void deleteToken() {
    final box = GetStorage();
    box.write("token", null);
    String? token = box.read("token");
    if (token == null) {}
  }

  static void saveToken(token) async {
    final box = GetStorage();
    box.write("token", token);
  }

  static String getToken() {
    final box = GetStorage();
    String? token = box.read("token");
    if (token != null) {
      return token;
    } else {
      return "null";
    }
  }

  static void deleteAdminToken() {
    final box = GetStorage();
    box.write("admintoken", null);
    String? token = box.read("admintoken");
    if (token == null) {}
  }

  static void saveAdminToken(token) {
    final box = GetStorage();
    box.write("admintoken", token);
  }

  static String getAdminToken() {
    final box = GetStorage();
    String? token = box.read("admintoken");
    if (token != null) {
      return token;
    } else {
      return "null";
    }
  }
}
