import 'package:flutter/foundation.dart';
import 'package:meds/core/models/logger_model.dart';
import 'package:meds/locator.dart';

class LoggerViewModel with ChangeNotifier {
  final LoggerModel _loggerModel = locator();

  bool isDebugging(String sectionName) => _loggerModel.isEnabled(sectionName);

  void setOption(String sectionName, bool value) {
    _loggerModel.saveSetting(sectionName, value);
    notifyListeners();
  }
}
