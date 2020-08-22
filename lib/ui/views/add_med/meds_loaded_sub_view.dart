import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/services/med_lookup_service.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/list_view_card.dart';

class MedsLoadedSubView extends StatelessWidget with Logger {
  final LoggerViewModel _logger = locator();
  final MedLookUpService model = locator();

  @override
  Widget build(BuildContext context) {
    setLogging(_logger.isLogging(ADDMED_LOGS));
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
                      bool editing = model.editIndex != null;
                      log(
                        'TempMed clicked: $index',
                        linenumber: lineNumber(StackTrace.current),
                      );
                      model.saveSelectedMed(index);
                      model.clearTempMeds();
                      model.clearNewMed();
                      log(
                        'Med saved, model meds cleared, form reset',
                        linenumber: lineNumber(StackTrace.current),
                      );
                      if (editing) {
                        Navigator.pop(context, model.wasMedAdded);
                        Navigator.pop(context);
                      } else
                        Navigator.pop(context, model.wasMedAdded);
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
                  bool editing = model.editIndex != null;
                  await model.saveMedNoMfg();
                  model.clearTempMeds();
                  model.clearNewMed();
                  log(
                    'Med saved, model meds cleared, form reset',
                    linenumber: lineNumber(StackTrace.current),
                  );
                  if (editing) {
                    Navigator.pop(context, model.wasMedAdded);
                    Navigator.pop(context);
                  } else
                    Navigator.pop(context, model.wasMedAdded);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
