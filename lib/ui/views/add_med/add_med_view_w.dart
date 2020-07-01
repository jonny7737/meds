import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_form.dart';
import 'package:provider/provider.dart';

class AddMedWidget extends StatelessWidget with Logger {
  AddMedWidget({this.editIndex});

  final int editIndex;

  @override
  Widget build(BuildContext context) {
    setDebug(true);

    AddMedViewModel _model = Provider.of(context, listen: false);
    _model.setEditIndex(editIndex);
    _model.logEditIndex();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
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
