import 'package:flutter/material.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/add_med_form.dart';
import 'package:provider/provider.dart';

class AddMedWidget extends StatelessWidget {
  const AddMedWidget({this.editIndex});

  final int editIndex;

  @override
  Widget build(BuildContext context) {
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
          title: Text('Add a Medication'),
          centerTitle: true,
        ),
        body: AddMedForm(),
      ),
    );
  }
}
