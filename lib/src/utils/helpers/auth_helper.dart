import 'package:book_my_spot_frontend/src/models/response.dart';
import 'package:book_my_spot_frontend/src/services/storageManager.dart';
import 'package:book_my_spot_frontend/src/utils/errors/auth/auth_errors.dart';

class AuthHelper {
  AuthHelper._();

  static UserAuth(Response response) {
    if (response.statusCode == 200) {
      saveToken(response.data);
    } else {
      throw AuthException(response.data);
    }
  }
}
