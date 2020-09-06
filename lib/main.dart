import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/hive_setup.dart';
import 'package:meds/locator.dart';
import 'package:meds/ui/router.dart';
import 'package:meds/ui/themes/theme_data_provider.dart';
import 'package:meds/ui/view_model/user_viewmodel.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
      color: Colors.yellow[100],
      debugShowCheckedModeBanner: false,
      title: 'Meds',
      theme: Provider.of<ThemeDataProvider>(context).themeData,
      initialRoute: setupRoute,
      onGenerateRoute: Router.generateRoute,
    );
  }
}
