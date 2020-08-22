import 'package:flutter/foundation.dart';
import 'package:meds/core/mixins/logger.dart';

class ScreenInfoViewModel with Logger {
  List<String> _setupCompleted = [];

  bool get isSetup => _setupCompleted.contains('S') && _setupCompleted.contains('P');

  bool _smallScreen = false;
  bool _mediumScreen = false;
  bool _largeScreen = false;

  void setScreenSize(diagonalInches) {
    if (_setupCompleted.contains('S')) return;
    _smallScreen = diagonalInches < 5.11;
    _mediumScreen = !_smallScreen && diagonalInches <= 5.6;
    _largeScreen = diagonalInches > 5.6;
    _setupCompleted.add('S');
  }

  bool get isSmallScreen => _smallScreen;
  bool get isMediumScreen => _mediumScreen;
  bool get isLargeScreen => _largeScreen;

  String get screenSize {
    String size = 'S';
    if (_mediumScreen) size = 'M';
    if (_largeScreen) size = 'L';
    return size;
  }

  TargetPlatform _platform = TargetPlatform.android;
  TargetPlatform get platform => _platform;
  void setPlatform(value) {
    if (_setupCompleted.contains('P')) return;
    _platform = value;
    if (_platform == TargetPlatform.iOS) {
      _setFontScale(0.79);
    } else
      _setFontScale(1.0);
    _setupCompleted.add('P');
  }

  double _fontScale = 1.0;
  double get fontScale => _fontScale;
  double _setFontScale(value) => _fontScale = value;

  bool get isiOS => platform == TargetPlatform.iOS;
  bool get isiOSLarge => isLargeScreen && platform == TargetPlatform.iOS;
  bool get isAndroid => platform == TargetPlatform.android;
}
