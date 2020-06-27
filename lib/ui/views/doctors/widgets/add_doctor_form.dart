import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:meds/ui/views/doctors/widgets/add_doctor_field.dart';
import 'package:meds/ui/views/doctors/widgets/submit_button.dart';

class AddDoctorForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('New Doctor Information'),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                AddDoctorField(
                  index: 0,
                  hint: 'Enter new Doctor\'s name',
                  fieldName: 'name',
                ),
                AddDoctorField(
                  index: 1,
                  hint: 'Enter Doctor\'s phone number',
                  fieldName: 'phone',
                ),
                PositionedSubmitButton(formKey: _formKey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
