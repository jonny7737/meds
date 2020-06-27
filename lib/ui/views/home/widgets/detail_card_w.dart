import 'package:flutter/material.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:meds/ui/views/home/widgets/detail_drop_cap_w.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class DetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomeViewModel _model = Provider.of(context, listen: false);
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      bottom: _model.cardBottom,
      left: context.widthPct(0.05),
      width: context.widthPct(0.90),
      child: GestureDetector(
        onTap: () {
          _model.hideDetailCard();
        },
        child: Container(
          height: context.heightPct(0.60),
          child: Card(
            shadowColor: Colors.blue,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: context.heightPct(0.010),
                  left: context.widthPct(0.10),
                  right: context.widthPct(0.10),
                  child: Text(
                    _model.activeMed.name,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      height: 0.95,
                      fontSize: context.heightPct(0.03),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                DetailDropCapWidget(
                  medData: _model.activeMed,
                  imageFile: _model.activeImageFile,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
