import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/core/constants.dart';

class LoggerMenuWidget extends StatefulWidget with Logger {
  @override
  _LoggerMenuWidgetState createState() => _LoggerMenuWidgetState();
}

class _LoggerMenuWidgetState extends State<LoggerMenuWidget> {
  final LoggerViewModel _model = locator();

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
          child: buildTile('Enable Logging', LOGGING_APP),
        ),
        Expanded(
          child: ListView(
            children: <Widget>[
              buildTile('Router', ROUTING_LOGS),
              buildTile('Splash Screen', SPLASH_LOGS),
              buildTile('Login', LOGIN_LOGS),
              buildTile('Home', HOME_LOGS),
              buildTile('Doctor', DOCTOR_LOGS),
              buildTile('Add Med', ADDMED_LOGS),
              buildTile('Med Repository', MED_REPOSITORY_LOGS),
              buildTile('Doctor Repository', DOCTOR_REPOSITORY_LOGS),
              buildTile('Network', NETWORK_LOGS),
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
      value: _model.isLogging(sectionName) ?? false,
      onChanged: (bool value) {
        _model.setOption(sectionName, value);
      },
    );
  }
}
