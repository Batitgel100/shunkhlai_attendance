import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shunhlai_attendance/app_types.dart';
import 'package:shunhlai_attendance/components/custom_drawer.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendance_entity.dart';
import 'package:shunhlai_attendance/screen/attendance%20register/camera_leave.dart';
import 'package:shunhlai_attendance/screen/attendance%20register/open_camera.dart';
import 'package:shunhlai_attendance/service/attendance/attendance_list_repo.dart';
import 'package:shunhlai_attendance/service/attendance/attendance_today.dart';
import 'package:shunhlai_attendance/service/company_name_repo.dart';
import 'package:shunhlai_attendance/service/attendance/register_attendance.dart';
import 'package:shunhlai_attendance/service/settings_repo.dart';
import 'package:shunhlai_attendance/utils/utils.dart';

class AttendanceRegisterScreen extends StatefulWidget {
  const AttendanceRegisterScreen({super.key});

  @override
  State<AttendanceRegisterScreen> createState() =>
      _AttendanceRegisterScreenState();
}

class _AttendanceRegisterScreenState extends State<AttendanceRegisterScreen> {
  var desiredLocation = LatLng(Globals.getlong(), Globals.getlat());
  double desiredRadius = 50.0;
  RegisterAttendance registerAttendance = RegisterAttendance();

  TodayWorkedHoursApiClient todayWorkedHourApiClient =
      TodayWorkedHoursApiClient();
  RegisterAttendanceLeft registerLeft = RegisterAttendanceLeft();
  EmployeDataApiClient employe = EmployeDataApiClient();
  bool isInLocation = false;
  DateTime end = DateTime.now();
  DateTime start30 = DateTime.now();
  bool cameRegistered = false;
  late Timer inactivityTimer;
  int storedId = 0;
  CompanyNameRepository getcompany = CompanyNameRepository();
  String capturedImageBase64 = '';
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  AttendanceToday today = AttendanceToday();

  @override
  void initState() {
    super.initState();
    getcompany.getCompanyName();
    startInactivityTimer();
    employe.getEmployeeData();
    _handleLocationPermission();
    checkLocation();
    getDate();
    _loadId();
    _onRefresh();
  }
  // Хэрэглэгчийг гаргах (600 секунд)

  void startInactivityTimer() {
    inactivityTimer = Timer(
      Duration(seconds: Globals.getTimer()),
      () {
        Navigator.pushReplacementNamed(
          context,
          RoutesName.login,
        );
      },
    );
  }

  Future<void> _loadId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storedId = prefs.getInt('stored_id') ?? 0;
    });
  }

// 30 өдөрийн өмнөх өдөр аль өдөр вэ?

  void getDate() {
    DateTime currentDate = DateTime.now();

    DateTime startDate30 = currentDate.subtract(const Duration(days: 30));

    DateTime endDate = currentDate;

    setState(() {
      start30 = startDate30;
      end = endDate;
    });
  }

  // Апп байршил тогтоох эрхийг нээсэн эсэхийг шалгах

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

// Байршил шалгах

  Future<void> checkLocation() async {
    final currentPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    final distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      desiredLocation.latitude,
      desiredLocation.longitude,
    );
    if (distance < 100) {
      isInLocation = true;
      setState(() {});
    } else {
      isInLocation = false;
    }
  }

  bool _refreshData = false;

  void registerCame() {
    if (isInLocation == true) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: const Text('Та итгэлтэй байна уу?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Үгүй'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      _onRefresh();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraApp(
                            onImageCaptured: (imageData) {
                              capturedImageBase64 = imageData;
                              setState(() {});
                              print('Captured Image Data: $imageData');
                            },
                            isInLocation: isInLocation,
                          ),
                        ),
                      );
                    },
                    child: const Text('Тийм'),
                  ),
                ],
              ));

      // Utils.flushBarSuccessMessage('Амжилттай бүртгэгдлээ.', context);
    } else {
      Utils.flushBarErrorMessage('Хол зайтай байна.', context);
    }
  }

//явсан ирц бүртгэх
  void registerLeeave() {
    today.fetchData();
    if (isInLocation == true) {
      if (Globals.getLeft() == false) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: const Text('Та итгэлтэй байна уу?'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Үгүй'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      _onRefresh();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CameraAppLeave(
                              onImageCaptured: (image) {},
                              isInLocation: isInLocation),
                        ),
                      );
                    },
                    child: const Text('Тийм'),
                  ),
                ],
              );
            });

        Globals.changeLeft(false);
      } else {
        Utils.flushBarErrorMessage(
            'Ирсэн тэмдэглэгээ хийгдээгүй байна', context);
      }
    } else {
      Utils.flushBarErrorMessage('Хол зайтай байна.', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: _appbar(),
      endDrawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(00.0),
        child: Center(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [BoxShadows.shadow3]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                            child: Icon(
                              Icons.calendar_month,
                              size: 30,
                              color: AppColors.mainColor,
                            ),
                          ),
                          // const SizedBox(
                          //   width: 5,
                          // ),
                          _buildThirtyDay(),
                        ],
                      ),
                    ],
                  ),
                ),
                _title(),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [BoxShadows.shadow3]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: const Icon(
                                      Icons.schedule,
                                      size: 30,
                                      color: AppColors.mainColor,
                                    ),
                                  ),
                                  cameRegistered
                                      ? SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.07,
                                          child: const Icon(
                                            Icons.schedule,
                                            size: 30,
                                            color: AppColors.mainColor,
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                          ),
                          _buildTodayWorkedHours(),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSmallButton(0.075, 0.45, registerCame,
                            AppColors.mainColor, 'Ирсэн'),
                        _buildSmallButton(0.075, 0.45, registerLeeave,
                            AppColors.mainColor, 'Явсан'),
                      ]),
                ),
                if (capturedImageBase64.isNotEmpty)
                  Row(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.23,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue, width: 3),
                              borderRadius: BorderRadius.circular(
                                  20), // Adjust the radius as needed
                              image: DecorationImage(
                                image: MemoryImage(
                                    base64Decode(capturedImageBase64)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            left: MediaQuery.of(context).size.width * 0.38,
                            child: InkWell(
                              onTap: () {
                                capturedImageBase64 = '';
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(60),
                                      color: Colors.red),
                                  child: const Icon(
                                    Icons.delete_forever,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _refreshData = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _refreshData = false;
    });
  }

  PreferredSize _appbar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, top: 0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                        boxShadow: [BoxShadows.shadow3]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 00.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.secondBlack,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Сайн байна уу?',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.secondBlack),
                                ),
                                Text(
                                  Globals.getUserName(),
                                  style: TextStyles.main16semibold,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _key.currentState!.openEndDrawer(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.09,
                    width: 100,
                    decoration: const BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        boxShadow: [BoxShadows.shadow3]),
                    child: const Icon(
                      Icons.menu,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Padding _title() {
    return const Padding(
      padding: EdgeInsets.only(left: 10.0, bottom: 0, top: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'ӨНӨӨДРИЙН ИРЦ',
            style: TextStyles.black16semibold,
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<AttendanceEnity>> _buildTodayWorkedHours() {
    return FutureBuilder<List<AttendanceEnity>>(
      future: AttendanceToday().fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Text('Алдаа заалаа');
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final attendanceList = snapshot.data!;

          final checkIn = attendanceList[0].checkIn ?? DateTime(2000);
          final checkOut = attendanceList[0].checkOut ?? DateTime(2000);

          DateTime now = DateTime.now();
          DateTime checkInDateTime = checkIn.add(const Duration(hours: 8));
          var formatter = DateFormat('HH:mm');
          String formattedCheckIn = formatter.format(checkInDateTime);

          DateTime checkOutDateTime = checkOut.add(const Duration(hours: 8));
          String formattedCheckOut = formatter.format(checkOutDateTime);

          bool cameRegistered = checkInDateTime.year == now.year &&
              checkInDateTime.month == now.month &&
              checkInDateTime.day == now.day;

          return cameRegistered
              ? SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          child: Center(
                            child: Text(
                              'Ирсэн цаг:   $formattedCheckIn',
                              style: TextStyles.black16,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.065,
                          child: Center(
                            child: Text(
                              'Явсан цаг:   ${formattedCheckOut == '08:00' ? "бүртгээгүй" : formattedCheckOut}',
                              style: TextStyles.black16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.075,
                    child: Center(
                      child: _refreshData
                          ? const CircularProgressIndicator(
                              color: AppColors.secondBlack,
                            )
                          : const Text(
                              'бүртгэл хийгдээгүй',
                              style: TextStyles.black16,
                            ),
                    ),
                  ),
                );
        } else {
          return const Center(child: Text('Мэдээлэл байхгүй'));
        }
      },
    );
  }

  Center _buildLoadingIndicator(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.secondBlack,
      ),
    );
  }

  // FutureBuilder<double> _buildThirtyDay() {
  //   return FutureBuilder<double>(
  //     future: AttendanceListApiClients().getTotalWorkedHours(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return _buildLoadingIndicator(context);
  //       } else if (snapshot.hasError) {
  //         print(snapshot.error);
  //         return const Text('Алдаа заалаа');
  //       } else if (!snapshot.hasData) {
  //         return const Text('Алдаа заалаа');
  //       } else {
  //         double totalWorkedHours = snapshot.data!;
  //         return _refreshData
  //             ? const CircularProgressIndicator(
  //                 color: AppColors.secondBlack,
  //               )
  //             : Padding(
  //                 padding: const EdgeInsets.symmetric(horizontal: .0),
  //                 child: Text(
  //                   '25 наас хойших ирц: ${totalWorkedHours.toStringAsFixed(2)} цаг',
  //                   style: TextStyles.black16,
  //                 ),
  //               );
  //       }
  //     },
  //   );
  // }
  FutureBuilder<double> _buildThirtyDay() {
    return FutureBuilder<double>(
      future: AttendanceListApiClients()
          .getTotalWorkedHours(Globals.getEmployeeId(), start30, end),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingIndicator(context);
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Text('Алдаа заалаа');
        } else if (!snapshot.hasData) {
          return const Text('hooson');
        } else {
          double totalWorkedHours = snapshot.data!;
          return _refreshData
              ? const CircularProgressIndicator(
                  color: AppColors.secondBlack,
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: .0),
                  child: Text(
                    '30 Хоногийн ирц: ${totalWorkedHours.toStringAsFixed(2)} цаг',
                    style: TextStyles.black16,
                  ),
                );
        }
      },
    );
  }

  Padding _buildSmallButton(double height, double width, VoidCallback ontap,
      Color color, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: ontap,
        child: Container(
          height: MediaQuery.of(context).size.height * height,
          width: MediaQuery.of(context).size.width * width * 0.95,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: color,
              boxShadow: const [BoxShadows.shadow3]),
          child: Center(
            child: Text(
              text,
              style: TextStyles.white16semibold,
            ),
          ),
        ),
      ),
    );
  }
}
