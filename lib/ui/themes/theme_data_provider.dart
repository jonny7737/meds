import 'package:flutter/material.dart';
import 'package:meds/ui/themes/theme_dark.dart';
import 'package:meds/ui/themes/theme_light.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeDataProvider with ChangeNotifier {
  bool _useDarkTheme;
  SharedPreferences _prefs;
  double _appMargin;
  int _animationDuration = 200;

  ThemeDataProvider() {
    _appMargin = 0.0;
    _useDarkTheme = false;
    _loadPrefs();
  }

  ThemeData get themeData => _useDarkTheme ? myThemeDark : myThemeLight;

  bool get isDarkTheme => _useDarkTheme;
  double get appMargin => _appMargin;
  int get animDuration => _animationDuration;

  ///
  /// Set the application working margin.
  ///
  void setAppMargin(double appMargin) {
    _appMargin = appMargin;
  }

  void toggleTheme() {
    _useDarkTheme = !_useDarkTheme;
    _savePrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  _loadPrefs() async {
    await _initPrefs();
    _useDarkTheme = _prefs.getBool("useDarkMode") ?? true;
    notifyListeners();
  }

  _savePrefs() async {
    await _initPrefs();
    await _prefs.setBool("useDarkMode", _useDarkTheme);
  }
}
