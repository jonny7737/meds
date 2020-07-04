import 'dart:core';

import 'package:meds/core/helpers/custom_trace.dart';

/// Enable / disable debug logging everywhere.
///
const bool DEBUGGING_APP = true;

/// These constants are application specific.  They allow me to
/// enable / disable debugging on a per code section basis.
///
/// This enables / disables logging in the AddMed code group.
///
const bool ADDMED_DEBUG = false;

/// This enables / disables logging in the Home code group.
///
const bool HOME_DEBUG = false;

/// This enables / disables logging in the Login code group.
///
const bool LOGIN_DEBUG = false;

/// This enables / disables logging in the Doctor code group.
///
const bool DOCTOR_DEBUG = false;

/// This enables / disables logging in the MedRepository code group.
///
const bool MED_REPOSITORY_DEBUG = false;

/// This enables / disables logging in the DoctorRepository code group.
///
const bool DOCTOR_REPOSITORY_DEBUG = false;

/// This enables / disables logging in the general Networking code group.
///
const bool NETWORK_DEBUG = true;

mixin Logger {
  final Boolean _debug = Boolean(false);

  bool get isLogging => _debug.value;

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
    if (!always && (!_debug.value || !DEBUGGING_APP)) return;

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
