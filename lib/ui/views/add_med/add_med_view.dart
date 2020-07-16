import 'package:flutter/material.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/add_med/error_message_viewmodel.dart';
import 'package:provider/provider.dart';

import 'add_med_view_w.dart';

class AddMedArguments {
  final int editIndex;

  AddMedArguments({this.editIndex});
}

class AddMedView extends StatelessWidget {
  AddMedView(this.editIndex);
  final int editIndex;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AddMedViewModel(),
        ),
        ChangeNotifierProvider.value(
          value: ErrorMessageViewModel(),
        ),
      ],
      child: AddMedWidget(editIndex: editIndex),
    );
  }
}
