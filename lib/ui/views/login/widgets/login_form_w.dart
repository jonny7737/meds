import 'package:flutter/material.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> _formKey;
  final Map<String, String> _formData;

  const LoginFormWidget({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required Map<String, String> formData,
  })  : _formKey = formKey,
        _formData = formData,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        autofocus: true,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Your first name",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        onChanged: (String value) {
          _formData["name"] = value;
        },
        onSaved: (String value) {
          FocusScope.of(context).unfocus();
          _formData['name'] = value.trim();
          _formKey.currentState.reset();
        },
      ),
    );
  }
}
