import 'package:flutter/material.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/views/login/login_w.dart';
import 'package:meds/ui/views/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeDataProvider themeDataProvider = Provider.of(context, listen: false);

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: themeDataProvider.isDarkTheme ? Colors.black87 : null,
        title: Text('Login'),
        actions: <Widget>[
          IconButton(
              tooltip: "Dark Mode On/Off",
              icon: Icon(
                themeDataProvider.isDarkTheme ? Icons.brightness_medium : Icons.brightness_3,
              ),
              onPressed: () {
                themeDataProvider.toggleTheme();
              })
        ],
      ),
      body: ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: LoginWidget(),
      ),
    ));
  }
}
