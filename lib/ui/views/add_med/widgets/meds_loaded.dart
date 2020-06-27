import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:provider/provider.dart';

class MedsLoaded extends StatelessWidget with Logger {
  @override
  Widget build(BuildContext context) {
    AddMedViewModel _model = Provider.of(context, listen: false);

    setDebug(false);

    log('${_model.numMedsFound} meds found', linenumber: lineNumber(StackTrace.current));
    return Stack(
      children: <Widget>[
        ListView.builder(
          itemCount: _model.numMedsFound,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                log('TempMed clicked: $index', linenumber: lineNumber(StackTrace.current));
                _model.setSelectedMed(index);
                _model.clearTempMeds();
              },
              child: ListTileBuilder(index),
            );
          },
        ),
      ],
    );
  }
}

class ListTileBuilder extends StatelessWidget {
  ListTileBuilder(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final AddMedViewModel _model = Provider.of(context, listen: false);

    return ListTile(
      title: Text(
        _model.medFound.imageInfo.mfgs[index],
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
