import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_field.dart';
import 'package:meds/ui/views/add_med/widgets/submit_button.dart';
import 'package:meds/ui/views/widgets/drop_down_formfield.dart';
import 'package:meds/ui/views/widgets/stack_modal_blur.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class AddMedForm extends StatelessWidget with Logger {
  final LoggerViewModel _logger = locator();

  final _formKey = GlobalKey<FormState>();

  void navigateToMedsLoadedView(BuildContext context, _model) {
    log('Navigating to MedsLoaded');
//    var args = MedsLoadedArguments(model: _model);
    Navigator.pushNamed(context, medsLoadedRoute);
  }

  @override
  Widget build(BuildContext context) {
    setLogging(_logger.isLogging(ADDMED_LOGS));
    AddMedViewModel _model = Provider.of(context, listen: true);

    _model.setFormKey(_formKey);

    if (_model.medsLoaded)
      Future.delayed(Duration(milliseconds: 500), () {
        navigateToMedsLoadedView(context, _model);
      });

    log(
      'Rebuilding Form [${_model.newMedName}] [FormKey ${_formKey != null}]',
      linenumber: lineNumber(StackTrace.current),
    );

    return Form(
      key: _formKey,
      child: Stack(
        children: <Widget>[
          AddMedField(
            index: 0,
            hint: 'Enter medication name',
            fieldName: 'name',
            onSave: (value) {
              _model.onFormSave('name', value);
              return null;
            },
          ),
          AddMedField(
            index: 1,
            hint: 'Enter medication dose (eg 10mg)',
            fieldName: 'dose',
            onSave: (value) {
              _model.onFormSave('dose', value);
              return null;
            },
          ),
          AddMedField(
            index: 2,
            hint: 'How often to take this medication',
            fieldName: 'frequency',
            onSave: (value) {
              _model.onFormSave('frequency', value);
              return null;
            },
          ),
          buildDoctorDropdown(context, _model),
          PositionedSubmitButton(formKey: _formKey),
          if (_model.isBusy || _model.medsLoaded)
            const StackModalBlur(),
//          if (_model.medsLoaded) ,
        ],
      ),
    );
  }

  Positioned buildDoctorDropdown(BuildContext context, AddMedViewModel _model) {
    return Positioned(
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
        child: Container(
          child: DropDownFormField(
            contentPadding: EdgeInsets.fromLTRB(14, 0, 14, 0),
            filled: false,
            titleText: null,
            errorText: null,
            hintText: 'Please choose one',
            value: _model.fancyDoctorName,
            onSaved: (value) {
              log('onSaved: $value', linenumber: lineNumber(StackTrace.current));
              _model.onFormSave('doctor', value);
            },
            onChanged: (value) {
              log('onChanged: $value', linenumber: lineNumber(StackTrace.current));
              _model.onFormSave('doctor', value);
            },
            dataSource: _model.doctorsForDropDown(),
            textField: 'display',
            valueField: 'value',
          ),
        ),
      ),
    );
  }
}
