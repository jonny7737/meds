import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/error_message_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_field.dart';
import 'package:meds/ui/views/add_med/widgets/editable_dropdown.dart';
import 'package:meds/ui/views/add_med/widgets/submit_button.dart';
import 'package:meds/ui/views/widgets/drop_down_formfield.dart';
import 'package:meds/ui/views/widgets/stack_modal_blur.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class AddMedForm extends StatelessWidget with Logger {
  final LoggerViewModel _logger = locator();
  final ScreenInfoViewModel _s = locator();

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 0.0);

  static final _formKey = GlobalKey<FormState>();
//  final FocusNode f1 = FocusNode();
//  final FocusNode f2 = FocusNode();
//  final FocusNode f3 = FocusNode();

  void navigateToMedsLoadedView(BuildContext context, _model) async {
    log('Navigating to MedsLoaded');
    bool medAdded = await Navigator.pushNamed(context, medsLoadedRoute);
    log('Med loading completed.. Med added: $medAdded', linenumber: lineNumber(StackTrace.current));
  }

  setErrorMessage(ErrorMessageViewModel em, bool saved, String fieldName) {
    if (saved)
      em.setFormError(false);
    else {
      em.showError(fieldName);
      em.setFormError(true);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    setLogging(_logger.isLogging(ADDMED_LOGS));
    AddMedViewModel _model = context.watch();
    ErrorMessageViewModel _em = context.watch();

    _model.setFormKey(_formKey);
    if (_s.isSmallScreen) _model.formScrollController = _scrollController;

    if (_model.medsLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateToMedsLoadedView(context, _model);
      });

      log('Meds Loaded...', linenumber: lineNumber(StackTrace.current));
    }

    log(
      'Rebuilding Form [${_model.newMedName}] [FormKey ${_formKey != null}]',
      linenumber: lineNumber(StackTrace.current),
    );

    return SingleChildScrollView(
      controller: _scrollController,
      child: Form(
        key: _formKey,
        child: Stack(
          children: <Widget>[
            Container(height: context.heightPct(1)),
            AddMedField(
              index: 0,
//              focusNode: f1,
              hint: 'Enter medication name',
              fieldName: 'name',
              onSave: (value) => setErrorMessage(_em, _model.onFormSave('name', value), 'name'),
            ),
            AddMedField(
              index: 1,
//              focusNode: f2,
              hint: 'Enter medication dose (eg 10mg)',
              fieldName: 'dose',
              onSave: (value) => setErrorMessage(_em, _model.onFormSave('dose', value), 'dose'),
            ),
            EditableDropdownWidget(
              index: 2,
//              focusNode: f3,
              fieldName: 'frequency',
              onSave: (value) => setErrorMessage(_em, _model.onFormSave('frequency', value), 'frequency'),
            ),
            buildDoctorDropdown(context, _model),
            PositionedSubmitButton(formKey: _formKey),
            if (_model.isBusy || _model.medsLoaded) const StackModalBlur(),
//          if (_model.medsLoaded) ,
          ],
        ),
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
