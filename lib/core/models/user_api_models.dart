class LoginResponse {
  final bool success;
  final int secondsToLogout;
  final String message;

  LoginResponse({this.success = true, this.secondsToLogout, this.message});
}

class LogoutResponse {
  final bool success;
  final String message;

  LogoutResponse({this.success, this.message});
}

class User {
  final String name;

  User({this.name});
}
