class LoginError implements Exception {
  final String error;
  LoginError(this.error);
  String handleError() {
    return "Oops , Error : ${error}";
  }
}
