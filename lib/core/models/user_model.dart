import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  SharedPreferences prefs;

  UserModel() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static const String _IS_LOGGED_IN = "is_logged_in";
  static const String _NAME = "name";
  static const String _EXPIRE = "expire";
  static const String _LOGIN_AT = "login_at";

  int get loggedInAt => prefs.getInt(_LOGIN_AT);

  int secondsToLogout() {
    var expirey = prefs.getInt(_EXPIRE);
    if (expirey == null) {
      return -1;
    } else {
      return (expirey - DateTime.now().millisecondsSinceEpoch ~/ 1000);
    }
  }

  Future<void> logout() async {
    prefs.remove(_IS_LOGGED_IN);
    prefs.remove(_NAME);
    prefs.remove(_EXPIRE);
    prefs.remove(_LOGIN_AT);
  }

  Future<void> login(String name) async {
    if (await isLoggedIn() == true) {
      return;
    }
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    /**
     * Require login at least once per day
     */
    var xp = now + (24 * 60 * 60);
    await prefs.setBool(_IS_LOGGED_IN, true);
    await prefs.setString(_NAME, name);
    await prefs.setInt(_EXPIRE, xp);
    await prefs.setInt(_LOGIN_AT, now);
  }

  Future<bool> isLoggedIn() async {
    if (prefs == null) await init();
    var expirey = prefs.getInt(_EXPIRE);
    if (expirey == null) {
      logout();
      return false;
    } else if (expirey < DateTime.now().millisecondsSinceEpoch ~/ 1000) {
      logout();
      return false;
    }
    return prefs.containsKey(_IS_LOGGED_IN);
  }

  Future<String> getName() async {
    return prefs.getString(_NAME);
  }
}
