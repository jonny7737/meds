import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/mixins/logger.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/screen_info_viewmodel.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:meds/ui/views/home/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:sized_context/sized_context.dart';

// ignore: must_be_immutable
class MedDrawer extends StatelessWidget with Logger {
  MedDrawer(this.toggleDrawer);

  Function toggleDrawer;

  @override
  Widget build(BuildContext context) {
    ScreenInfoViewModel _s = locator<ScreenInfoViewModel>();
    UserViewModel userViewModel = locator();
    HomeViewModel _model = Provider.of(context, listen: false);

    double fontSize = context.heightPct(_s.isLargeScreen ? 0.023 : 0.025) * _s.fontScale;

    return SafeArea(
      child: Material(
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints.expand(
                width: double.infinity,
                height: context.heightPct(0.16),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Provider.of<ThemeDataProvider>(context).appMargin,
              ),
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: context.heightPct(0.10),
                    child: Image.asset("assets/meds.png"),
                  ),
                  Text(
                    'Options',
                    style: TextStyle(
                      fontSize: context.heightPct(0.03),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                'Logout',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                userViewModel.logout();
                Navigator.pushReplacementNamed(context, loginRoute);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text(
                'Manage Medications',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () async {
                log('Number of Doctors available: ${_model.numberOfDoctors}');
                if (_model.numberOfDoctors == 0) {
                  _model.showAddMedError();
                  return;
                } else {
                  toggleDrawer();
                  bool result = await Navigator.pushNamed<bool>(context, addMedRoute);
                  if (result != null && result) {
                    _model.modelDirty(true);
                  }
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle),
              title: Text(
                'Manage Doctors',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () async {
                toggleDrawer();
                bool result = await Navigator.pushNamed(context, doctorRoute);
                if (result != null && result) {
                  _model.modelDirty(true);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_forever),
              title: Text(
                'Clear ALL Data',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                _model.clearListData();
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Debug Options',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                toggleDrawer();
                Navigator.pushNamed(context, debugMenuRoute);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About',
                style: TextStyle(fontSize: fontSize),
              ),
              onTap: () {
                /**
                 * TODO: Convert showAboutDialog to a custom widget
                          so that all elements can be configured.
                 **/
                showAboutDialog(
                  context: context,
                  applicationIcon: Image.asset(
                    'assets/meds.png',
                    height: context.heightPct(0.15),
                  ),
                  applicationName: 'Meds',
                  applicationVersion: 'v-0.6.8',
                  children: [
                    Text(
                      'All drug information provided by U.S. National Institute of Health API.'
                      '  Not appropriate for use with non-U.S. drugs.\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Icon made by Dark Web from www.flaticon.com\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Icon made by ultimatearm from www.flaticon.com\n',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    ),
                    Text(
                      'Options drawer made by\n\t\tMarcin Szałek',
                      style: TextStyle(
                        fontSize: context.heightPct(0.020),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
