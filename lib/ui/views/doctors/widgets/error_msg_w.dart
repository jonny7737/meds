import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/doctors/doctors_viewmodel.dart';
import 'package:sized_context/sized_context.dart';
import 'package:flutter/material.dart';

class DoctorErrorMsgWidget extends StatefulWidget {
  final String error;
  DoctorErrorMsgWidget({@required this.error});
  @override
  _DoctorErrorMsgWidgetState createState() => _DoctorErrorMsgWidgetState();
}

class _DoctorErrorMsgWidgetState extends State<DoctorErrorMsgWidget> {
  DoctorsViewModel _model = locator();
  @override
  initState() {
    _model.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    _model.removeListener(update);
    super.dispose();
  }

  update() => setState(() => {});

  @override
  Widget build(BuildContext context) {
    ScreenInfoViewModel _s = locator<ScreenInfoViewModel>();
    double errorMsgHeight = _model.errorMsgHeight(widget.error);
    String errorMsg = _model.errorMsg(widget.error);
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
          duration: Duration(milliseconds: 300),
          alignment: Alignment.center,
          height: errorMsgHeight,
          width: context.widthPct(0.75),
          color: Colors.transparent,
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: Text(
            errorMsg,
            softWrap: false,
            style: TextStyle(
              fontSize: _s.isiOS ? 15 : 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
