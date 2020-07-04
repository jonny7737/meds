import 'package:flutter/widgets.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:meds/ui/views/home/widgets/home_view_w.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:meds/ui/views/home/custom_drawer.dart';

class HomeView extends StatelessWidget with Logger {
  @override
  Widget build(BuildContext context) {
    setDebug(HOME_DEBUG);

    Widget screen = HomeViewWidget();
    screen = CustomDrawer(child: screen);

    log('(Re)building', linenumber: lineNumber(StackTrace.current));

    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: screen,
    );
  }
}
