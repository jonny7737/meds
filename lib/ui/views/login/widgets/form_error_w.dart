import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:meds/ui/views/login/login_view_model.dart';

class FormErrorWidget extends StatelessWidget {
  final String errorMsg;

  FormErrorWidget({this.errorMsg});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData =
        Provider.of<ThemeDataProvider>(context, listen: false).themeData;

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 4,
        color: themeData.colorScheme.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 275),
          alignment: Alignment.center,
          height: Provider.of<LoginViewModel>(context).errorMsgHeight,
          width: context.widthPct(0.60),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
          child: Text(
            errorMsg,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
