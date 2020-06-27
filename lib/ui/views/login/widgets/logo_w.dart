import 'package:flutter/material.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:sized_context/sized_context.dart';
import 'package:provider/provider.dart';

/// returns an AnimatedPositioned widget for a Stack
class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeDataProvider themeDataProvider =
        Provider.of<ThemeDataProvider>(context, listen: false);

    bool _kbVisible = context.mq.viewInsets.bottom > 10;
    bool _smallScreen = context.diagonalInches < 5.0;
    bool _mediumScreen = !_smallScreen && context.diagonalInches < 5.6;
    bool _largeScreen = context.diagonalInches > 5.6;

    double topPos;
    double lrPos;

    if (_smallScreen) {
      topPos = _kbVisible ? context.heightPct(0.14) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.30) : context.widthPct(0.10);
    } else if (_mediumScreen) {
      topPos = _kbVisible ? context.heightPct(0.13) : context.heightPct(0.18);
      lrPos = _kbVisible ? context.widthPct(0.22) : context.widthPct(0.10);
    } else if (_largeScreen) {
      topPos = _kbVisible ? context.heightPct(0.10) : context.heightPct(0.14);
      lrPos = _kbVisible ? context.widthPct(0.15) : context.widthPct(0.10);
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: themeDataProvider.animDuration),
      top: topPos,
      left: lrPos,
      right: lrPos,
      child: Container(
        child: Image.asset("assets/meds.png"),
      ),
    );
  }
}
