import 'dart:core';

import 'package:meds/core/constants.dart';
import 'package:meds/core/helpers/custom_trace.dart';

mixin Logger {
  final Boolean _debug = Boolean(false);

  bool get isLogging => _debug.value;

  void setDebug(bool d) {
    _debug.value = d;
  }

  /// Usage:
  ///   lineNumber(StackTrace.current)
  ///
  int lineNumber(StackTrace trace) {
    return CustomTrace(trace).lineNumber;
  }

  void log(String msg, {int linenumber = -1, bool always = false}) {
    if (!always && (!_debug.value || !DEBUGGING_APP)) return;

    String source = this.runtimeType.toString();
    if (linenumber < 0)
      print('[$source]-> $msg');
    else
      print('[$source.$linenumber]-> $msg');
  }
}

class Boolean {
  bool value = false;
  Boolean(bool b) : value = b;
}
