import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/response_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]);

  Future<List<User>> fetchAllUsers() async {
    Response response = await HttpHelper.makeRequest(
        RequestTypes.get, RequestGroup.other, "user");
    if (response.statusCode == 200) {
      List<User> users = [];
      for (int i = 0; i < response.data.length; i++) {
        User user = User(response.data[i]["id"]);
        user = await user.userFromJSON();
        users.add(user);
      }
      state = users;
      return users;
    }

    return [];
  }
}

final allUsersProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

final userFutureProvider = FutureProvider<User>((ref) async {
  User u = User(StorageManager.getToken().toString());
  return await u.userFromJSON();
});

final userProvider = StateProvider<User>((ref) {
  return User(StorageManager.getToken().toString());
});
