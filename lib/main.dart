import 'package:flutter/material.dart';
import 'package:shunhlai_attendance/app_types.dart';
import 'package:shunhlai_attendance/constant/constant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.mainColor,
          // ···
          // brightness: Brightness.,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutesName.login,
      // home: MyWidget(),
    );
  }
}
