import 'dart:core';

import 'package:meds/core/helpers/custom_trace.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';

mixin Logger {
  final LoggerViewModel _model = locator();
  final Boolean _debug = Boolean(false);

  bool get isLogging => _debug.value && _model.isDebugging('debugging_app');

  void setDebug(bool d) {
    _debug.value = d;
  }

  /// Usage:
  ///   ```lineNumber(StackTrace.current)```
  ///
  int lineNumber(StackTrace trace) {
    return CustomTrace(trace).lineNumber;
  }

  /// [log()] A function to print a message to the console.
  ///
  ///     1. [msg]: The String to be logged
  ///
  ///     2. [linenumber]: Optional and enables the logging
  ///     to include the line number of the call to log.
  ///
  ///     3. [always]: Optionally flag a log call to ALWAYS log the message
  ///
  /// Example:
  /// ```dart
  ///     log('Message to log', linenumber: lineNumber(StackTrace.current);
  /// ```
  ///
  void log(String msg, {int linenumber, bool always = false}) {
    if (!always && (!_debug.value || !_model.isDebugging('debugging_app'))) return;

    /// This is to determine the calling Class type so it can be included in the output.
    String source = this.runtimeType.toString();
    if (linenumber == null)
      print('[$source]-> $msg');
    else
      print('[$source.$linenumber]-> $msg');
  }
}

/// This class allows me to store the DEBUGGING flag more
/// cleanly in a StatelessWidget or other immutable object.
///
class Boolean {
  bool value = false;
  Boolean(bool b) : value = b;
}
