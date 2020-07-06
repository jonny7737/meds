import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/doctors/doctors_viewmodel.dart';
import 'package:sized_context/sized_context.dart';

class PositionedSubmitButton extends StatelessWidget with Logger {
  PositionedSubmitButton({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final DoctorsViewModel _model = locator();
  final ScreenInfoViewModel _screen = locator();
  final DebugViewModel _debug = locator();

  @override
  Widget build(BuildContext context) {
    setDebug(_debug.isDebugging(DOCTOR_DEBUG));
    return Positioned(
      left: context.widthPct(0.30),
      right: context.widthPct(0.30),
      top: _screen.isLargeScreen ? context.heightPct(0.25) : context.heightPct(0.30),
      child: RaisedButton(
        elevation: 30,
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          log('pressed');
          SystemChannels.textInput.invokeMethod('TextInput.hide');

          /// Check form for errors by calling the field onSave function
          /// I didn't use the validate function because I want custom error UX
          _formKey.currentState.save();

          // If form has no errors AND form has a new med has been set
          if (!_model.formHasErrors && _model.hasNewDoctor) {
            _model.saveDoctor();
            _formKey.currentState.reset();
            _model.clearNewDoctor();
            log('Form Validated', linenumber: lineNumber(StackTrace.current));
            Navigator.pop(context);

            // If form has errors OR no new med set
          } else {
            log(
              'FormErrors: ${_model.formHasErrors}',
              linenumber: lineNumber(StackTrace.current),
            );
            _model.clearFormError();
          }
        },
        child: Text(
          'Continue',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
