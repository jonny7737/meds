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

class SetupScreenInfo extends StatelessWidget with Logger {
  final LoggerViewModel _debug = locator();

  void navigateToSplashScreen(BuildContext context) {
    log('Navigating to SplashPage');
    Navigator.pushReplacementNamed(context, splashRoute);
  }

  @override
  Widget build(BuildContext context) {
    ScreenInfoViewModel _s = locator();

    Widget screen = SafeArea(child: Material(color: Colors.yellow[300]));

    setLogging(_debug.isLogging(LOGGING_APP));

    if (_s.isSetup) return screen;

    //  This is the first 'context' with a MediaQuery, therefore,
    //  this is the first opportunity to set these values.
    Provider.of<ThemeDataProvider>(context, listen: false).setAppMargin(context.widthPct(0.10));

    _s.setPlatform(Theme.of(context).platform);
    _s.setScreenSize(context.diagonalInches);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      log('Navigating to SplashPage');
      Navigator.pushReplacementNamed(context, splashRoute);
    });
    
    return screen;
  }
}
