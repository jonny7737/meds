import 'package:shared_preferences/shared_preferences.dart';
import 'package:meds/core/constants.dart';

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

  Map<String, bool> get debugSettings {
    if (prefs == null) return {};
    Map<String, bool> settings = {};
    settings.putIfAbsent(DEBUGGING_APP, () => prefs.getBool(DEBUGGING_APP));
    settings.putIfAbsent(ADDMED_DEBUG, () => prefs.getBool(ADDMED_DEBUG));
    settings.putIfAbsent(HOME_DEBUG, () => prefs.getBool(HOME_DEBUG));
    settings.putIfAbsent(LOGIN_DEBUG, () => prefs.getBool(LOGIN_DEBUG));
    settings.putIfAbsent(DOCTOR_DEBUG, () => prefs.getBool(DOCTOR_DEBUG));
    settings.putIfAbsent(MED_REPOSITORY_DEBUG, () => prefs.getBool(MED_REPOSITORY_DEBUG));
    settings.putIfAbsent(DOCTOR_REPOSITORY_DEBUG, () => prefs.getBool(DOCTOR_REPOSITORY_DEBUG));
    settings.putIfAbsent(NETWORK_DEBUG, () => prefs.getBool(NETWORK_DEBUG));
    return settings;
  }

  void saveDebugSettings(Map<String, bool> settings) {
    if (prefs == null) return;
    settings.forEach((k, v) async {
      await prefs.setBool(k, v);
    });
  }
}
