import 'package:flutter/foundation.dart';
import 'package:meds/core/mixins/logger.dart';

class ScreenInfoViewModel with Logger {
  int _setupComplete = 0;
  bool get isSetup => _setupComplete == 2;

  bool _smallScreen = false;
  bool _mediumScreen = false;
  bool _largeScreen = false;
  void setScreenSize(diagonalInches) {
    _smallScreen = diagonalInches < 5.11;
    _mediumScreen = !_smallScreen && diagonalInches <= 5.6;
    _largeScreen = diagonalInches > 5.6;
    if (_setupComplete < 2) _setupComplete++;
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
    _platform = value;
    if (_platform == TargetPlatform.iOS) {
      _setFontScale(0.79);
    } else
      _setFontScale(1.0);
    if (_setupComplete < 2) _setupComplete++;
  }

  double _fontScale = 1.0;
  double get fontScale => _fontScale;
  double _setFontScale(value) => _fontScale = value;

  bool get isiOS => platform == TargetPlatform.iOS;
  bool get isiOSLarge => isLargeScreen && platform == TargetPlatform.iOS;
  bool get isAndroid => platform == TargetPlatform.android;
}
