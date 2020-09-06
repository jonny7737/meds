import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class SetupScreenInfo extends StatefulWidget with Logger {
  @override
  _SetupScreenInfoState createState() => _SetupScreenInfoState();
}

class _SetupScreenInfoState extends State<SetupScreenInfo> {
  final ScreenInfoViewModel _s = locator();
  final LoggerViewModel _debug = locator();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Function log;
  Function lineNumber;
  Function setLogging;

  initState() {
    log = widget.log;
    lineNumber = widget.lineNumber;
    setLogging = widget.setLogging;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('${context.toString()}', linenumber: lineNumber(StackTrace.current));
      if (context == null) return;
      log('Navigating to SplashPage');
      Navigator.pushReplacementNamed(context, splashRoute);
    });

    super.initState();
  }

  bool setup(BuildContext context) {
    if (_s.isSetup || _s.runningSetup) return false;
    _s.runningSetup = true;

    //  This is the first 'context' with a MediaQuery, therefore,
    //  this is the first opportunity to set these values.
    Provider.of<ThemeDataProvider>(context, listen: false).setAppMargin(context.widthPct(0.10));

    _s.setPlatform(Theme.of(context).platform);
    _s.setScreenSize(context.diagonalInches);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    setLogging(_debug.isLogging(LOGGING_APP));

    if (setup(context)) log('setup() returned', linenumber: lineNumber(StackTrace.current));

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Material(color: Colors.yellow[300]),
      ),
    );
  }
}
