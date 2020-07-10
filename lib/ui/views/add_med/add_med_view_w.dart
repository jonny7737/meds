import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_form.dart';
import 'package:provider/provider.dart';

class AddMedWidget extends StatelessWidget with Logger {
  final LoggerViewModel _logs = locator();

  AddMedWidget({this.editIndex});

  final int editIndex;

  @override
  Widget build(BuildContext context) {
    AddMedViewModel _model = Provider.of(context, listen: false);

    setLogging(_logs.isLogging(ADDMED_LOGS));

    _model.setMedForEditing(editIndex);
    _model.logEditIndex();

    log('Rebuilding [Edit Index: $editIndex]', linenumber: lineNumber(StackTrace.current));

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              if (_model.medsLoaded) {
                _model.formKey.currentState?.reset();
                _model.clearTempMeds();
                _model.setMedsLoaded(false);
              } else
                Navigator.pop(context, _model.wasMedAdded);
            },
          ),
          actions: <Widget>[
            IconButton(
                color: Colors.white,
                tooltip: 'Add a new Doctor',
                icon: ImageIcon(
                  AssetImage('assets/doctor.png'),
                ),
                onPressed: () {
                  log('Add a new Doctor', linenumber: lineNumber(StackTrace.current));
                  Navigator.pushNamed(context, addDoctorRoute);
                }),
          ],
          title: Text('Add a Medication'),
          centerTitle: true,
        ),
        body: AddMedForm(),
      ),
    );
  }
}
