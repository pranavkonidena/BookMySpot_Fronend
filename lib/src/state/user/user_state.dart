import 'package:book_my_spot_frontend/src/state/date/date_state.dart';
import 'package:book_my_spot_frontend/src/utils/api/user_api.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_groups.dart';
import 'package:book_my_spot_frontend/src/utils/enums/request_types.dart';
import 'package:book_my_spot_frontend/src/utils/helpers/http_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_my_spot_frontend/src/models/user.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';

// I need to fix this

final userFutureProvider = FutureProvider<User>((ref) async {
  User u = User(getToken());
  return await u.userFromJSON();
});

final userProvider = StateProvider<User>((ref) {
  return User(getToken());
});


