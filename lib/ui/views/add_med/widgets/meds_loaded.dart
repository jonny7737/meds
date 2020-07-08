import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/widgets/list_view_card.dart';
import 'package:provider/provider.dart';

class MedsLoaded extends StatelessWidget with Logger {
  final DebugViewModel _debug = locator();
  final _formKey;
//  = GlobalKey<FormState>()
  MedsLoaded(this._formKey);

  @override
  Widget build(BuildContext context) {
    AddMedViewModel _model = Provider.of(context, listen: false);

    setDebug(_debug.isDebugging(ADDMED_DEBUG));

    log('${_model.numMedsFound} meds found', linenumber: lineNumber(StackTrace.current));
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2,
          left: 10,
          right: 10,
          bottom: 80,
          child: ListView.builder(
            itemCount: _model.numMedsFound,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  int editIndex = _model.editIndex;
                  log('TempMed clicked: $index', linenumber: lineNumber(StackTrace.current));
                  _model.saveSelectedMed(index);
                  _model.clearTempMeds();
                  log('Edit Index: ${_model.editIndex}', linenumber: lineNumber(StackTrace.current));
                  _model.clearNewMed();
                  _formKey.currentState?.reset();
                  if (editIndex != null) {
                    Navigator.pop(context, _model.wasMedAdded);
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
              int editIndex = _model.editIndex;
              await _model.saveMedNoMfg();
              _model.clearTempMeds();
              _model.clearNewMed();
              _formKey.currentState?.reset();
              log('Med saved, model meds cleared, form reset', linenumber: lineNumber(StackTrace.current));
              if (editIndex != null) {
                Navigator.pop(context, _model.wasMedAdded);
              }
            },
          ),
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
