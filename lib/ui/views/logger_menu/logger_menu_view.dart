import 'package:flutter/material.dart';

import 'package:meds/ui/views/logger_menu/logger_menu_w.dart';

class LoggerMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log Options'),
        ),
        body: LoggerMenuWidget(),
      ),
    );
  }
}
