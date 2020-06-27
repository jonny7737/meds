import 'dart:ui';

import 'package:flutter/material.dart';

class StackModalBlur extends StatelessWidget {
  const StackModalBlur({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
