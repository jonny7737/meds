import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sized_context/sized_context.dart';

import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:provider/provider.dart';

class SetupScreenInfo extends StatelessWidget with Logger {
  void navigateToSplashScreen(BuildContext context) {
    log('Navigating to SplashPage');
    Navigator.pushReplacementNamed(context, splashRoute);
  }

  @override
  Widget build(BuildContext context) {
    ScreenInfoViewModel _s = locator();
    setLogging(false);

    if (_s.isSetup) return SafeArea(child: Material(color: Colors.yellow[300]));

    //  This is the first 'context' with a MediaQuery, therefore,
    //  this is the first opportunity to set these values.
    Provider.of<ThemeDataProvider>(context, listen: false).setAppMargin(context.widthPct(0.10));

    _s.setPlatform(Theme.of(context).platform);
    double screenSize = context.diagonalInches;
    _s.setScreenSize(screenSize);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    if (_kbVisible) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }

    Future.delayed(Duration(milliseconds: 50), () {
      navigateToSplashScreen(context);
    });

    return SafeArea(child: Material(color: Colors.yellow[300]));
  }
}
