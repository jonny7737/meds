import 'dart:io';

import 'package:drop_cap_text/drop_cap_text.dart';
import 'package:flutter/material.dart';
import 'package:meds/core/helpers/hero_dialog_route.dart';
import 'package:meds/core/models/med_data.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/views/widgets/med_image_hero.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:sized_context/sized_context.dart';

class DetailDropCapWidget extends StatelessWidget {
  DetailDropCapWidget({
    Key key,
    @required this.medData,
    @required this.imageFile,
  }) : super(key: key);

  final MedData medData;
  final File imageFile;

  final ScreenInfoViewModel _s = locator<ScreenInfoViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: context.widthPct(0.06),
        left: context.widthPct(0.06),
        top: medData.name.length > 25 ? context.heightPct(0.09) : context.heightPct(0.06),
        bottom: context.heightPct(0.02),
      ),
      child: SingleChildScrollView(
        child: DropCapText(
          medData.info.length != 0 ? medData.info[0] : 'No MedData available',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: _s.isLargeScreen ? context.heightPct(0.020) : context.heightPct(0.025),
          ),
          dropCap: DropCap(
            width: context.widthPct(0.35),
            height: context.heightPct(0.15),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(0.005),
                vertical: context.heightPct(0.01),
              ),
              child: GestureDetector(
                onTap: () {
                  if (medData.info.length == 0) {
                    return;
                  }
                  Navigator.push(
                    context,
                    HeroDialogRoute(
                      builder: (BuildContext context) {
                        return MedImageHero(
                          id: 'detailMedImage${medData.id}',
                          imageFile: imageFile,
                          imageUrl: medData.imageURL,
                        );
                      },
                    ),
                  );
                },
                child: Hero(
                  tag: 'detailMedImage${medData.id}',
                  child: imageFile == null
                      ? Container(color: Colors.transparent)
                      : Material(
                          color: Colors.transparent,
                          child: Image(
                            image: NetworkToFileImage(file: imageFile, url: medData.imageURL),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
