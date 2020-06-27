import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_field.dart';
import 'package:meds/ui/views/add_med/widgets/meds_loaded.dart';
import 'package:meds/ui/views/add_med/widgets/submit_button.dart';
import 'package:meds/ui/views/widgets/stack_modal_blur.dart';
import 'package:provider/provider.dart';

class AddMedForm extends StatelessWidget with Logger {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    setDebug(false);
    AddMedViewModel _model = Provider.of(context);

    String _name;
    String _dose;
    String _frequency;

    if (_model.editIndex != null) {
      _name = _model.medAtEditIndex.name;
      _dose = _model.medAtEditIndex.dose;
      _frequency = _model.medAtEditIndex.frequency;
    }

    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          AddMedField(
            index: 0,
            initialValue: _name,
            hint: 'Enter medication name',
            error: 'name',
            onSave: (value) {
              _model.onFormSave('name', value);
              return null;
            },
          ),
          AddMedField(
            index: 1,
            initialValue: _dose,
            hint: 'Enter medication dose (eg 10mg)',
            error: 'dose',
            onSave: (value) {
              _model.onFormSave('dose', value);
              return null;
            },
          ),
          AddMedField(
            index: 2,
            initialValue: _frequency,
            hint: 'How often to take this medication',
            error: 'frequency',
            onSave: (value) {
              _model.onFormSave('frequency', value);
              return null;
            },
          ),
          PositionedSubmitButton(formKey: _formKey),
          if (_model.isBusy || _model.medsLoaded) const StackModalBlur(),
          if (_model.medsLoaded) MedsLoaded(),
        ],
      ),
    );
  }
}
