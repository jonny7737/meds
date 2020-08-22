import 'dart:io';

import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:sized_context/sized_context.dart';

class MedImageHero extends StatelessWidget {
  final String id;
  final File imageFile;
  final String imageUrl;

  const MedImageHero({
    Key key,
    @required this.id,
    @required this.imageFile,
    @required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Hero(
              tag: id,
              child: Container(
                child: Image(
                  image: NetworkToFileImage(
                    file: imageFile,
                    url: imageUrl,
                  ),
                  width: context.widthPct(0.85),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
