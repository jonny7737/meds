import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:meds/core/models/user_model.dart';

class UserViewModel with ChangeNotifier {
  final UserModel userModel;

  //TODO: Change this to use GetIt package.
  UserViewModel({@required this.userModel});

  String _name;
  bool _isLoggedIn;
  Timer loggedInTimer;
  int _secondsToLogout;

  init() async {
    await _refreshAllStates();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get name => _name;

  int get logoutTime {
    if (userModel.secondsToLogout() != _secondsToLogout) {
      _secondsToLogout = userModel.secondsToLogout();
    }
    return _secondsToLogout;
  }

  bool get shouldLogin {
    if (logoutTime > 0) {
      return false;
    }
    return true;
  }

  _refreshAllStates() async {
    _isLoggedIn = await userModel.isLoggedIn();
    _name = await userModel.getName();
    notifyListeners();
  }

  login(String userName) async {
    userName = userName.trim();
    await userModel.login(userName);
    await _refreshAllStates();
    //startLoggedInTimer();
  }

  logout() async {
    await userModel.logout();
    await _refreshAllStates();
    //stopLoggedInTimer();
  }

//  void tikTok() {
//    print(loggedInTimer.tick);
//  }

  void stopLoggedInTimer() {
    if (loggedInTimer != null && loggedInTimer.isActive) {
      loggedInTimer.cancel();
      print("LoggedInTimer canceled.");
    }
  }

  void startLoggedInTimer() async {
    stopLoggedInTimer();
    const to = const Duration(seconds: 20);
    loggedInTimer = Timer.periodic(to, (Timer t) async {
      //tikTok();
      if (!await userModel.isLoggedIn()) {
        print("Automatic logout triggered.");
        logout();
      }
    });
  }

  @override
  void dispose() {
    loggedInTimer.cancel();
    super.dispose();
  }
}
