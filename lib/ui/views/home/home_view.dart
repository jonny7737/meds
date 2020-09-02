import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/views/home/custom_drawer.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:meds/ui/views/home/widgets/home_view_w.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget with Logger {
  final LoggerViewModel _debug = locator();
  
  @override
  Widget build(BuildContext context) {
    setLogging(_debug.isLogging(HOME_LOGS));
    log('(Re)building', linenumber: lineNumber(StackTrace.current));

    Widget screen = HomeViewWidget();
    screen = CustomDrawer(child: screen);

    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: screen,
    );
  }
}
