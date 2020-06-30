import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';

// ignore: must_be_immutable
class SplashView extends StatefulWidget with Logger {
  @override
  _SplashViewState createState() {
    setDebug(false);
    log('createState executing');
    return _SplashViewState();
  }
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), doneLoading);
  }

  doneLoading() async {
    /**
     * TODO: try{} was necessary because the context was null
              after adding SetupScreenInfo as the home route.
              the reason for the null context is still unknown.
              Fix IT!!
     */
    try {
      UserViewModel userViewModel = locator();

      widget.setDebug(false);

      if (userViewModel.shouldLogin) {
        widget.log('Executing Login Route');
        Navigator.pushReplacementNamed(context, loginRoute);
      } else {
        widget.log('Executing Home Route');
        Navigator.pushReplacementNamed(context, homeRoute);
      }
    } catch (e) {}
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
                margin: EdgeInsets.symmetric(horizontal: _margin),
                child: Image.asset("assets/meds.png"),
              ),
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
