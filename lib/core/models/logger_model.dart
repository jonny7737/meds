import 'package:shared_preferences/shared_preferences.dart';

class LoggerModel {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;

  LoggerModel() {
    init();
  }

  Future init() async {
    prefs = await _prefs;
  }

  bool isEnabled(String sectionName) {
    bool enabled = prefs?.getBool(sectionName);
    return enabled ?? false;
  }

  void saveSetting(String sectionName, bool value) {
    prefs.setBool(sectionName, value);
    return;
  }

  void saveDebugSettings(Map<String, bool> settings) {
    if (prefs == null) return;
    settings.forEach((k, v) async {
      prefs.setBool(k, v);
      return;
    });
  }
}
