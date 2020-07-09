import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/helpers/hero_dialog_route.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/core/models/temp_med.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/logger_viewmodel.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/add_med/add_med_viewmodel.dart';
import 'package:meds/ui/views/widgets/med_image_hero.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

class ListViewCard extends StatelessWidget with Logger {
  final LoggerViewModel _debug = locator();

  ListViewCard({
    Key key,
    @required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    ScreenInfoViewModel _s = locator();
    AddMedViewModel _model = Provider.of(context, listen: false);

    TempMed tempMed = _model.medFound;

    setDebug(_debug.isDebugging(ADDMED_DEBUG));
    return Card(
      margin: EdgeInsets.only(
        top: context.heightPct(0.014),
        left: context.widthPct(0.025),
        right: context.widthPct(0.025),
      ),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                HeroDialogRoute(
                  builder: (BuildContext context) {
                    return MedImageHero(
                      id: 'medImage$index',
                      imageFile: null, //_model.imageFile(tempMed.rxcui),
                      imageUrl: tempMed.imageInfo.urls[index],
                    );
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(0.06),
                vertical: 2.0,
              ),
              child: Hero(
                tag: 'medImage$index',
                child: Container(
                  height: context.heightPct(0.08),
                  child: Image(
                    image: NetworkToFileImage(
                      file: null, //_model.imageFile(tempMed.rxcui),
                      url: tempMed.imageInfo.urls[index],
//                      debug: isLogging,
                    ),
                    width: context.widthPct(_s.isLargeScreen ? 0.19 : 0.15),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            right: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            top: context.heightPct(0.006),
            child: Container(
              width: context.widthPct(0.50),
              child: Text(
                tempMed.name,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  height: 0.9,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: context.heightPct(_s.isLargeScreen ? 0.022 : 0.028) * _s.fontScale,
                ),
              ),
            ),
          ),
          Positioned(
            right: context.widthPct(0.025),
            child: Text(
              _model.newMedDose,
              style: TextStyle(
                color: Colors.black,
                fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.025) * _s.fontScale,
              ),
            ),
          ),
          Positioned(
            left: context.widthPct(_s.isLargeScreen ? 0.28 : 0.23),
            bottom: _s.isiOS ? 2.0 : 0.0,
            child: Container(
              width: context.widthPct(0.60),
              child: Text(
                '${tempMed.imageInfo.mfgs[index]}',
                maxLines: 2,
                style: TextStyle(
                  color: Colors.black,
                  height: 0.9,
                  fontSize: context.heightPct(_s.isLargeScreen ? 0.020 : 0.024) * _s.fontScale * 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
