import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:meds/ui/views/login/widgets/login_button_w.dart';
import 'package:meds/ui/views/login/widgets/logo_w.dart';
import 'package:meds/ui/views/login/widgets/user_name_w.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

import 'package:meds/ui/views/login/login_view_model.dart';

class LoginWidget extends StatefulWidget with Logger {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {'name': null};

  void loginButtonClicked() async {
    var userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (_formData['name'] != null && _formData['name'].length > 2) {
      _formKey.currentState.save();
      widget.log(
        "Login name: ${_formData['name']}",
        linenumber: widget.lineNumber(StackTrace.current),
      );
      await userViewModel.login(_formData['name']);
      _formData['name'] = null;

      Navigator.pushReplacementNamed(context, homeRoute);
    } else
      Provider.of<LoginViewModel>(context, listen: false).showNameError();
  }

  @override
  Widget build(BuildContext context) {
    widget.setDebug(false);
    return Container(
      height: context.heightPx,
      child: Stack(
        children: <Widget>[
          UserNameWidget(formKey: _formKey, formData: _formData),
          LogoWidget(),
          LoginButtonWidget(loginButtonClicked),
        ],
      ),
    );
  }
}
