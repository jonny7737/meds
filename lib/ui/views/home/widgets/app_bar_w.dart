import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/debug_viewmodel.dart';
import 'package:meds/ui/views/home/custom_drawer.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

import 'package:meds/ui/view_model/user_viewmodel.dart';

class HomeAppBar extends StatelessWidget with Logger implements PreferredSizeWidget {
  final UserViewModel userViewModel = locator();
  final DebugViewModel _debug = locator();
  @override
  Widget build(BuildContext context) {
    final ThemeDataProvider themeDataProvider = Provider.of(context, listen: false);
    final String userName = userViewModel.name;
    final HomeViewModel _model = Provider.of(context);

    setDebug(_debug.isDebugging(HOME_DEBUG));
    return AppBar(
      backgroundColor: themeDataProvider.isDarkTheme ? Colors.black87 : null,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => CustomDrawer.of(context).open(),
          );
        },
      ),
      title: userName == null
          ? Text('Not Logged In')
          : Container(
              width: context.widthPct(0.30),
              child: Text(
                'Welcome $userName',
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
      actions: <Widget>[
        IconButton(
          tooltip: "Add a new medication",
          icon: Icon(Icons.add_circle, color: Colors.white),
          padding: EdgeInsets.all(0.0),
          onPressed: () async {
            log('Number of Doctors available: ${_model.numberOfDoctors}');
            if (_model.numberOfDoctors == 0) {
              _model.showAddMedError();
              return;
            } else {
              bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
              if (result != null && result) {
                _model.modelDirty(true);
              }
            }
          },
        ),
        IconButton(
          tooltip: "Dark Mode On/Off",
          icon: Icon(
            themeDataProvider.isDarkTheme ? Icons.brightness_medium : Icons.brightness_3,
            color: Colors.white,
          ),
          padding: EdgeInsets.all(0.0),
          onPressed: () {
            themeDataProvider.toggleTheme();
          },
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
