import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class PositionedSubmitButton extends StatelessWidget with Logger {
  final ScreenInfoViewModel _s = locator();
  final DebugViewModel _debug = locator();

  PositionedSubmitButton({
    Key key,
    @required GlobalKey<FormState> formKey,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    AddMedViewModel _model = Provider.of(context, listen: false);
    setDebug(_debug.isDebugging(ADDMED_DEBUG));

    return Positioned(
      left: context.widthPct(0.30),
      right: context.widthPct(0.30),
      top: _s.isLargeScreen ? context.heightPct(0.45) : context.heightPct(0.60),
      child: RaisedButton(
        elevation: 30,
        color: Theme.of(context).primaryColor,
        onPressed: () async {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // Check form for errors
          _formKey.currentState.save();

          // If form has no errors AND form has a new med has been set
          if (!_model.formHasErrors && _model.hasNewMed) {
            _model.clearTempMeds();
            if (await _model.getMedInfo()) {
              _formKey.currentState?.reset();
              log('Form Validated', linenumber: lineNumber(StackTrace.current));
            } else {
              if (_s.isAndroid) {
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return materialAlertDialog(context, _model);
                  },
                );
              } else if (_s.isiOS) {
                _showCupertinoErrorDialog(context);
              }
            }
            // Else if form has errors OR no new med set
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

  Future<void> _showCupertinoErrorDialog(BuildContext context) async {
    AddMedViewModel _model = Provider.of(context, listen: false);

    bool networkIssue = false;
    if (_model.rxcuiComment == null) networkIssue = true;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Medication Info ERROR'),
          content: networkIssue
              ? Text(
                  'There was a problem getting the information for the medication '
                  'name and dose you provided \n\n\tA network error occurred.\n\n '
                  'Please check your internet connection and try again',
                )
              : Text(
                  'NIH had a problem getting the information for the medication '
                  'name and dose you provided \n\n\t_model.rxcuiComment\n\n '
                  'Please check the medication name and dose and try again',
                ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  AlertDialog materialAlertDialog(BuildContext context, AddMedViewModel _model) {
    ThemeDataProvider themeDataProvider = Provider.of(context, listen: false);

    bool networkIssue = false;
    if (_model.rxcuiComment == null) networkIssue = true;

    return AlertDialog(
      title: Text('Medication Info ERROR'),
      backgroundColor: themeDataProvider.isDarkTheme ? Colors.grey[600] : Colors.white,
      elevation: 20.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30.0)),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            if (networkIssue) Text('There was a problem getting the'),
            if (!networkIssue) Text('NIH had a problem getting the'),
            Text('information for the medication'),
            Text('name and dose you provided'),
            Text('\n\t${_model.rxcuiComment ?? 'A network error occurred.'}\n'),
            if (networkIssue) Text('Please check your internet connection and try again'),
            if (!networkIssue) Text('Please check the medication name and dose and try again'),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
