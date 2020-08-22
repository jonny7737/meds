import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class ErrorMsgWidget extends StatelessWidget {
  const ErrorMsgWidget();

  @override
  Widget build(BuildContext context) {
    final HomeViewModel _model = Provider.of(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        elevation: 4,
        color: Colors.red[800],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 275),
          alignment: Alignment.center,
          height: _model.errorMsgHeight,
          width: context.widthPct(kErrorMsgWidthPercent),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 10, right: 10),
          child: Text(
            _model.errorMsg,
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
