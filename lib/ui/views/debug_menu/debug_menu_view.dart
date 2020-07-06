import 'package:flutter/material.dart';

import 'package:meds/ui/views/debug_menu/debug_menu_w.dart';

class DebugMenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Options'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print("meds: DebugMenu");
            },
          )
        ],
      ),
      body: DebugMenuWidget(),
    );
  }
}
