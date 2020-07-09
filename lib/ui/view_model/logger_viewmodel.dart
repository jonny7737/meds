import 'package:flutter/foundation.dart';
import 'package:meds/core/models/logger_model.dart';
import 'package:meds/locator.dart';

class DebugViewModel with ChangeNotifier {
  final LoggerModel _loggerModel = locator();

  Map<String, bool> get settings => _loggerModel.debugSettings;

  bool isDebugging(String sectionName) => _loggerModel.isEnabled(sectionName);

  void setOption(String sectionName, bool value) {
    _loggerModel.saveSetting(sectionName, value);
    notifyListeners();
  }
}
