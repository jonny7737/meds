import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/list_view_card.dart';

class MedsLoaded extends StatelessWidget with Logger {
  MedsLoaded(this.model);

  final LoggerViewModel _logger = locator();
  final AddMedViewModel model;

  @override
  Widget build(BuildContext context) {
//    AddMedViewModel _model = Provider.of(context, listen: false);

    setLogging(_logger.isLogging(ADDMED_LOGS));

    log('${model.numMedsFound} meds found', linenumber: lineNumber(StackTrace.current));
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 10,
          right: 10,
          bottom: 80,
          child: ListView.builder(
            itemCount: model.numMedsFound,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  int editIndex = model.editIndex;
                  log(
                    'TempMed clicked: $index',
                    linenumber: lineNumber(StackTrace.current),
                  );
                  model.saveSelectedMed(index);
                  model.clearTempMeds();
                  model.clearNewMed();
                  model.formKey.currentState.reset();
                  model.setState();
                  log(
                    'Med saved, model meds cleared, form reset',
                    linenumber: lineNumber(StackTrace.current),
                  );
                  if (editIndex != null) {
                    Navigator.pop(context, model.wasMedAdded);
                  }
                },
                child: ListViewCard(index: index),
              );
            },
          ),
        ),
        Positioned(
          bottom: 20,
          left: 60,
          right: 60,
          child: RaisedButton(
            color: Theme.of(context).primaryColor,
            child: Text(
              'Manufacturer not listed',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              int editIndex = model.editIndex;
              await model.saveMedNoMfg();
              model.clearTempMeds();
              model.clearNewMed();
              model.formKey.currentState.reset();
              model.setState();
              log(
                'Med saved, model meds cleared, form reset',
                linenumber: lineNumber(StackTrace.current),
              );
              if (editIndex != null) {
                Navigator.pop(context, model.wasMedAdded);
              }
            },
          ),
        ),
      ],
    );
  }
}
