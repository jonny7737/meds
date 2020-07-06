import 'package:flutter/foundation.dart';
import 'package:meds/core/models/debug_model.dart';
import 'package:meds/locator.dart';

class DebugViewModel with ChangeNotifier {
  final DebugModel _debugModel = locator();

  Map<String, bool> get settings => _debugModel.debugSettings;

  bool isDebugging(String sectionName) => _debugModel.isEnabled(sectionName);

  void setOption(String sectionName, bool value) {
    _debugModel.saveSetting(sectionName, value);
    notifyListeners();
  }
}
