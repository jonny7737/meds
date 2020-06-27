import 'package:flutter/widgets.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:meds/ui/views/home/widgets/home_view_w.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:meds/ui/views/home/custom_drawer.dart';

class HomeView extends StatelessWidget {
  static const String id = 'HomeScreen';

  @override
  Widget build(BuildContext context) {
    Widget screen = HomeViewWidget();
    screen = CustomDrawer(child: screen);
    return ChangeNotifierProvider(
      create: (_) => HomeViewModel(),
      child: screen,
    );
  }
}
