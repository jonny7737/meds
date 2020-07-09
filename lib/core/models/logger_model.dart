import 'package:shared_preferences/shared_preferences.dart';

class LoggerModel {
  SharedPreferences prefs;

  LoggerModel() {
    init();
  }

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  bool isEnabled(String sectionName) => prefs.getBool(sectionName) ?? false;

  void saveSetting(String sectionName, bool value) {
    prefs.setBool(sectionName, value);
//    print('Saved $sectionName : $value');
  }

  void saveDebugSettings(Map<String, bool> settings) {
    if (prefs == null) return;
    settings.forEach((k, v) async {
      await prefs.setBool(k, v);
    });
  }
}
