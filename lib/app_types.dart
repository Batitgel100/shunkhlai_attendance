import 'package:flutter/material.dart';
import 'package:shunhlai_attendance/screen/attendance%20register/attendance_list_screen.dart';
import 'package:shunhlai_attendance/screen/attendance%20register/attendance_register_screen.dart';
import 'package:shunhlai_attendance/screen/login/login_screen.dart';
import 'package:shunhlai_attendance/screen/main/main_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.attendanceRegister:
        return MaterialPageRoute(
            builder: (BuildContext context) =>
                const AttendanceRegisterScreen());

      case RoutesName.attendanceScreen:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AttendanceListScreen());
      // builder: (BuildContext context) => const MyWidget());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const LoginScreen());
      case RoutesName.main:
        return MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen());
      case RoutesName.productScreen:

      // case RoutesName.item:
      //   return MaterialPageRoute(
      //       builder: (BuildContext context) => const CountItemScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}

class RoutesName {
  static const String attendanceRegister = 'attendanceRegister';
  static const String attendanceScreen = 'attendanceScreen';
  static const String countScreen = 'countScreen';
  static const String countItemScreen = 'countItemScreen';

  static const String login = 'login';
  static const String item = 'item';
  static const String productScreen = 'product_screen';

  //home screen routes name
  static const String main = 'main_screen';
}
