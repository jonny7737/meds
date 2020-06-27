import 'package:flutter/foundation.dart';

class LoginViewModel with ChangeNotifier {
  final double _errorMsgMaxHeight = 35;
  double _nameErrorMsgHeight = 0.0;

  double get errorMsgHeight => _nameErrorMsgHeight;

  void showNameError() {
    _setNameErrorHeight(_errorMsgMaxHeight);
    Future.delayed(Duration(seconds: 2), () => {_setNameErrorHeight(0)});
  }

  void _setNameErrorHeight(double height) {
    _nameErrorMsgHeight = height;
    notifyListeners();
  }
}
