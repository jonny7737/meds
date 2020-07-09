import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/core/constants.dart';

class DebugMenuWidget extends StatefulWidget with Logger {
  @override
  _DebugMenuWidgetState createState() => _DebugMenuWidgetState();
}

class _DebugMenuWidgetState extends State<DebugMenuWidget> {
  final DebugViewModel _model = locator();

  Function log;
  Function lineNumber;

  @override
  void initState() {
    _model.addListener(updateWidget);
    log = widget.log;
    lineNumber = widget.lineNumber;
    super.initState();
  }

  @override
  void dispose() {
    _model.removeListener(updateWidget);
    super.dispose();
  }

  void updateWidget() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.grey,
          child: buildTile('Enable Debugging', DEBUGGING_APP),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              buildTile('Splash Screen Debugging', SPLASH_DEBUG),
              buildTile('Login Debugging', LOGIN_DEBUG),
              buildTile('Home Debugging', HOME_DEBUG),
              buildTile('Doctor Debugging', DOCTOR_DEBUG),
              buildTile('Add Med Debugging', ADDMED_DEBUG),
              buildTile('Med Repository Debugging', MED_REPOSITORY_DEBUG),
              buildTile('Doctor Repository Debugging', DOCTOR_REPOSITORY_DEBUG),
              buildTile('Network Debugging', NETWORK_DEBUG),
            ],
          ),
        ),
      ],
    );
  }

  CheckboxListTile buildTile(String title, String sectionName) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      activeColor: Colors.red,
      checkColor: Colors.white,
      value: _model.isDebugging(sectionName) ?? false,
      onChanged: (bool value) {
        _model.setOption(sectionName, value);
      },
    );
  }
}
