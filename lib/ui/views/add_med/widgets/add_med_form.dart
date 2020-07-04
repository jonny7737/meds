import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_field.dart';
import 'package:meds/ui/views/add_med/widgets/meds_loaded.dart';
import 'package:meds/ui/views/add_med/widgets/submit_button.dart';
import 'package:meds/ui/views/widgets/stack_modal_blur.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class AddMedForm extends StatelessWidget with Logger {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    setDebug(ADDMED_DEBUG);
    AddMedViewModel _model = Provider.of(context);

    log('Rebuilding Form [${_model.fancyDoctorName}]', linenumber: lineNumber(StackTrace.current));
    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          AddMedField(
            index: 0,
            initialValue: _model.newMedName,
            hint: 'Enter medication name',
            error: 'name',
            onSave: (value) {
              _model.onFormSave('name', value);
              return null;
            },
          ),
          AddMedField(
            index: 1,
            initialValue: _model.newMedDose,
            hint: 'Enter medication dose (eg 10mg)',
            error: 'dose',
            onSave: (value) {
              _model.onFormSave('dose', value);
              return null;
            },
          ),
          AddMedField(
            index: 2,
            initialValue: _model.newMedFrequency,
            hint: 'How often to take this medication',
            error: 'frequency',
            onSave: (value) {
              _model.onFormSave('frequency', value);
              return null;
            },
          ),
          Positioned(
            top: 30 + 3 * 80.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0.0, 5.0),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(horizontal: context.widthPct(0.10)),
              alignment: Alignment.center,
              width: context.widthPct(0.80),
              child: Center(
                child: DropdownButton<String>(
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,

                  value: _model.fancyDoctorName,
                  underline: Container(), // this removes underline
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24.0, // can be changed, default: 24.0
                  iconEnabledColor: Colors.blue,
                  items: _model.doctorNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String value) {
                    log(
                      'New doctor selected: $value',
                      linenumber: lineNumber(StackTrace.current),
                    );
                    _model.onFormSave('doctor', value);
                  },
                ),
              ),
            ),
          ),
          PositionedSubmitButton(formKey: _formKey),
          if (_model.isBusy || _model.medsLoaded) const StackModalBlur(),
          if (_model.medsLoaded) MedsLoaded(),
        ],
      ),
    );
  }
}
