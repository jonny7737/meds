import 'package:flutter/material.dart';
import 'package:meds/core/constants.dart';
import 'package:meds/setup_screen_info.dart';
import 'package:meds/ui/views/add_med/add_med_view.dart';
import 'package:meds/ui/views/doctors/doctors_view.dart';
import 'package:meds/ui/views/doctors/widgets/add_doctor_form.dart';
import 'package:meds/ui/views/home/home_view.dart';
import 'package:meds/ui/views/login/login_view.dart';
import 'package:meds/ui/views/splash_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case setupRoute:
        return PageRouteBuilder(
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
          pageBuilder: (_, __, ___) => SetupScreenInfo(),
        );
      case splashRoute:
        return PageRouteBuilder(
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
          pageBuilder: (_, __, ___) => SplashView(),
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
