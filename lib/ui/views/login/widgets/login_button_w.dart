import 'package:flutter/material.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class LoginButtonWidget extends StatelessWidget {
  final Function onButtonClick;

  LoginButtonWidget(this.onButtonClick);

  @override
  Widget build(BuildContext context) {
    final ThemeDataProvider themeDataProvider =
        Provider.of<ThemeDataProvider>(context, listen: false);
    final ThemeData themeData = themeDataProvider.themeData;

    var _kbVisible = context.mq.viewInsets.bottom > 10;
    bool _smallScreen = context.diagonalInches < 5.0;
    bool _mediumScreen = !_smallScreen && context.diagonalInches < 5.6;
    bool _largeScreen = context.diagonalInches > 5.6;

//    print("Dia Inches: ${context.diagonalInches}");
//    print("$_smallScreen : $_mediumScreen : $_largeScreen");

    double top;
    if (_smallScreen) {
      top = _kbVisible ? context.heightPct(0.36) : context.heightPct(0.75);
    } else if (_mediumScreen) {
      top = _kbVisible ? context.heightPct(0.42) : context.heightPct(0.65);
    } else if (_largeScreen) {
      top = _kbVisible ? context.heightPct(0.43) : context.heightPct(0.60);
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: themeDataProvider.animDuration),
      top: top,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: themeDataProvider.appMargin,
          right: themeDataProvider.appMargin,
        ),
        child: RaisedButton(
          animationDuration: Duration(milliseconds: 750),
          color: themeData.colorScheme.primary,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            'LOGIN',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            onButtonClick();
          },
        ),
      ),
    );
  }
}
