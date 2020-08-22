import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/add_med/error_message_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class ErrorMsgWidget extends StatelessWidget {
  final String fieldName;

  ErrorMsgWidget({@required this.fieldName});

  @override
  Widget build(BuildContext context) {
    final ErrorMessageViewModel _model = Provider.of(context);
    final ScreenInfoViewModel _s = locator();
    
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
          height: _model.errorMsgHeight(fieldName),
          width: context.widthPct(kErrorMsgWidthPercent),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: Text(
            _model.errorMsg(fieldName),
            softWrap: false,
            style: TextStyle(
              fontSize: _s.isiOS ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
