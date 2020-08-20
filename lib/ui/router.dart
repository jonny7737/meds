import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/core/models/logger_model.dart';
import 'package:meds/locator.dart';
import 'package:meds/setup_screen_info.dart';
import 'package:meds/ui/views/add_med/add_med_view.dart';
import 'package:meds/ui/views/add_med/meds_loaded_sub_view.dart';
import 'package:meds/ui/views/logger_menu/logger_menu_view.dart';
import 'package:meds/ui/views/doctors/doctors_view.dart';
import 'package:meds/ui/views/doctors/widgets/add_doctor_form.dart';
import 'package:meds/ui/views/home/home_view.dart';
import 'package:meds/ui/views/login/login_view.dart';
import 'package:meds/ui/views/splash_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    LoggerModel _model = locator();
    bool isLogging = _model.isEnabled(ROUTING_LOGS) && _model.isEnabled(LOGGING_APP);
    if (isLogging) print('[Router] => ${settings.name}  Arguments: ${settings.arguments.toString()}');

    switch (settings.name) {
      case setupRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SetupScreenInfo(),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
      case splashRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => SplashView(),
          transitionDuration: Duration(milliseconds: 1000),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return Align(
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
        );
      case loggerMenuRoute:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => LoggerMenuView(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return effectMap[PageTransitionType.slideUp](
              Curves.linear,
              animation,
              secondaryAnimation,
              child,
            );
          },
        );
      case loginRoute:
        return MaterialPageRoute(
          builder: (_) => LoginView(),
        );
      case homeRoute:
        return MaterialPageRoute(
          builder: (_) => HomeView(),
        );
      case addMedRoute:
        AddMedArguments args = settings.arguments;
        int _editIndex;
        if (args != null) _editIndex = args.editIndex;
        return MaterialPageRoute<bool>(
          builder: (_) => AddMedView(_editIndex),
        );
      case medsLoadedRoute:
        return PageRouteBuilder<bool>(
          pageBuilder: (_, __, ___) => MedsLoadedSubView(),
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return effectMap[PageTransitionType.slideUp](
              Curves.linear,
              animation,
              secondaryAnimation,
              child,
            );
          },
        );
      case doctorRoute:
        return MaterialPageRoute<bool>(
          builder: (_) => DoctorsView(),
        );
      case addDoctorRoute:
        return MaterialPageRoute<bool>(
          builder: (_) => AddDoctorForm(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => SafeArea(
            child: Scaffold(
              body: Center(
                child: Text('No route defined for ${settings.name}'),
              ),
            ),
          ),
        );
    }
  }
}
