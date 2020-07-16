import 'package:flutter/foundation.dart';
import 'package:meds/core/mixins/logger.dart';

class ErrorMessageViewModel extends ChangeNotifier with Logger {
  bool _isDisposed = false;

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    log('Has been disposed.', linenumber: lineNumber(StackTrace.current));
    super.dispose();
  }

  int _formErrors = 0;
  double nameErrorMsgHeight = 0;
  double doseErrorMsgHeight = 0;
  double frequencyErrorMsgHeight = 0;

  final double _errorMsgMaxHeight = 35;
  final String nameErrorMsg = 'Medication name is required.';
  final String doseErrorMsg = 'Dosage information is required.';
  final String frequencyErrorMsg = 'This information is required.';
  final Duration _secondsToDisplayErrorMsg = Duration(seconds: 4);

  bool get formHasErrors {
    if (_formErrors != 0) {
      return true;
    }
    return false;
  }

  void setFormError(bool errors) {
    errors ? _formErrors++ : _formErrors--;
    if (_formErrors < 0) _formErrors = 0;
  }

  void clearFormError() => _formErrors = 0;

  double errorMsgHeight(String error) {
    if (error == 'name') return nameErrorMsgHeight;
    if (error == 'dose') return doseErrorMsgHeight;
    if (error == 'frequency') return frequencyErrorMsgHeight;
    return 100.0;
  }

  String errorMsg(String error) {
    if (error == 'name') return nameErrorMsg;
    if (error == 'dose') return doseErrorMsg;
    if (error == 'frequency') return frequencyErrorMsg;
    return 'Unknown ERROR';
  }

  void showError(String error) {
//    log('$error requested', linenumber: lineNumber(StackTrace.current));
    _setErrorHeight(error: error, height: _errorMsgMaxHeight);
    Future.delayed(
      _secondsToDisplayErrorMsg,
      () {
        _setErrorHeight(error: error, height: 0);
        log('$error notification completed', linenumber: lineNumber(StackTrace.current));
      },
    );
  }

  void _setErrorHeight({String error, double height}) {
    if (_isDisposed) {
      log('ErrorMessageViewModel was disposed');
      return;
    }
    if (error == 'name') nameErrorMsgHeight = height;
    if (error == 'dose') doseErrorMsgHeight = height;
    if (error == 'frequency') frequencyErrorMsgHeight = height;
    notifyListeners();
  }
}
