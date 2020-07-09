import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/hive_setup.dart';
import 'package:meds/locator.dart';
import 'package:provider/provider.dart';

import 'package:meds/ui/router.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  HiveSetup();

  UserViewModel userViewModel = locator();
  await userViewModel.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeDataProvider>(
          create: (_) => ThemeDataProvider(),
        ),
      ],
      child: MedsApp(),
    ),
  );
}

class MedsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeDataProvider themeDataProvider = Provider.of(context);
    bool isDarkTheme = themeDataProvider.isDarkTheme;

    final ThemeData currentTheme = themeDataProvider.themeData.copyWith(
      scaffoldBackgroundColor: isDarkTheme ? Colors.yellow[600] : Colors.yellow[200],
    );
    return MaterialApp(
      color: Colors.yellow[100],
      debugShowCheckedModeBanner: false,
      title: 'Meds',
      theme: currentTheme,
      initialRoute: setupRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
