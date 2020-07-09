import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';

class SplashView extends StatefulWidget with Logger {
  final LoggerViewModel _debug = locator();

  @override
  _SplashViewState createState() {
    setDebug(_debug.isDebugging(SPLASH_DEBUG));
    log('createState executing');
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView> {
  Function log;
  Function lineNumber;

  @override
  void initState() {
    log = widget.log;
    lineNumber = widget.lineNumber;

    super.initState();
    Future.delayed(Duration(seconds: 2), doneLoading);
  }

  doneLoading() async {
    UserViewModel userViewModel = locator();

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
    ScreenInfoViewModel _screen = locator();

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    double _margin;
    if (_kbVisible && _screen.isSmallScreen || _screen.isMediumScreen) {
      _margin = context.widthPct(0.30);
    } else if (!_kbVisible || _screen.isLargeScreen) _margin = Provider.of<ThemeDataProvider>(context).appMargin;

    return SafeArea(
      child: Scaffold(
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
