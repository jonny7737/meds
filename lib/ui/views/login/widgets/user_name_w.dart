import 'package:flutter/material.dart';
import 'package:sized_context/sized_context.dart';

import 'package:meds/ui/views/login/widgets/login_form_w.dart';
import 'form_error_w.dart';

class UserNameWidget extends StatelessWidget {
  UserNameWidget({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required Map<String, String> formData,
  })  : _formKey = formKey,
        _formData = formData,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final Map<String, String> _formData;

  @override
  Widget build(BuildContext context) {
    var smallScreen = context.diagonalInches < 5.2;
    return Container(
        height: smallScreen ? context.heightPct(0.08) : context.heightPct(0.06),
        margin: EdgeInsets.only(
          top: context.heightPct(0.02),
          left: context.widthPct(0.10),
          right: context.widthPct(0.10),
        ),
        child: Stack(
          children: <Widget>[
            Material(
              elevation: 10.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  bottom: 10.0,
                ),
                child: LoginFormWidget(
                  formKey: _formKey,
                  formData: _formData,
                ),
              ),
            ),
            FormErrorWidget(errorMsg: 'Name is required')
          ],
        ));
  }
}
