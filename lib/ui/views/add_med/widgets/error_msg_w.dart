import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ErrorMsgWidget extends StatelessWidget {
  final String error;

  ErrorMsgWidget({@required this.error});

  @override
  Widget build(BuildContext context) {
    final AddMedViewModel _model = Provider.of(context);
    final ScreenInfoViewModel _s = locator<ScreenInfoViewModel>();

    double errorMsgHeight = _model.errorMsgHeight(error);
    String errorMsg = _model.errorMsg(error);
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
          height: errorMsgHeight,
          width: context.widthPct(0.75),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: Text(
            errorMsg,
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
