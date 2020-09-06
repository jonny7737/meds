import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class SplashView extends StatefulWidget with Logger {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final LoggerViewModel _debug = locator();
  final UserViewModel userViewModel = locator();
  final ScreenInfoViewModel _s = locator();

  Function log;
  Function lineNumber;
  Function setLogging;

  @override
  void initState() {
    log = widget.log;
    lineNumber = widget.lineNumber;
    setLogging = widget.setLogging;

    setLogging(_debug.isLogging(SPLASH_LOGS));

    Future.delayed(Duration(seconds: 2), doneLoading);
    super.initState();
  }

  doneLoading() {
    if (context == null) return;
    if (userViewModel.shouldLogin) {
      log('Executing Login Route');
      Navigator.pushReplacementNamed(context, loginRoute);
    } else {
      log('Executing Home Route');
      Navigator.pushReplacementNamed(context, homeRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    double _margin;
    if (_kbVisible && _s.isSmallScreen || _s.isMediumScreen) {
      _margin = context.widthPct(0.30);
    } else if (!_kbVisible || _s.isLargeScreen)
      _margin = Provider
          .of<ThemeDataProvider>(context)
          .appMargin;
    
    return SafeArea(
      child: Scaffold(
        key: UniqueKey(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  decoration: null,
                  margin: EdgeInsets.symmetric(horizontal: _margin),
                  child: Image.asset(
                    "assets/meds.png",
                  )),
              SizedBox(
                height: 10,
              ),
              SpinKitDoubleBounce(
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
