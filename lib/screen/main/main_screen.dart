import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/screen/attendance%20register/attendance_register_screen.dart';
import 'package:shunhlai_attendance/screen/settings/settings_screen.dart';
import 'package:shunhlai_attendance/service/settings_repo.dart';

import '../../service/company_name_repo.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  EmployeDataApiClient employee = EmployeDataApiClient();
  CompanyNameRepository companyName = CompanyNameRepository();
  @override
  void initState() {
    super.initState();
    getEmployee();
    companyName.getCompanyName();
  }

  void getEmployee() {
    employee.getEmployeeData();
  }

  // Future<void> scanBarcode(BuildContext context) async {
  //   String barcodeScanRes;

  //   try {
  //     barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666',
  //       'Cancel',
  //       true,
  //       ScanMode.BARCODE,
  //     );
  //     print('barcode data: $barcodeScanRes');

  //     if (barcodeScanRes != '-1') {
  //       if (barcodeScanRes != '-1') {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => FakeProductScreen(barcode: barcodeScanRes),
  //           ),
  //         );
  //       }
  //       //navigate
  //     }
  //   } on PlatformException catch (e) {
  //     if (e.code == 'USER_CANCELLED') {
  //       print('Barcode scanning cancelled by user');
  //     } else {
  //       print('Failed to scan barcode: ${e.message}');
  //     }
  //   }
  // }

  // void _scan() async {
  //   await scanBarcode(context);
  // }

  int _selectedIndex = 0;

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Нүүр',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Хэрэглэгч',
    ),
  ];
  static final List<Widget> _pages = <Widget>[
    const AttendanceRegisterScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _scan(),
      //   backgroundColor: AppColors.secondBlack,
      //   child: const Icon(
      //     Icons.barcode_reader,
      //     color: Colors.white,
      //   ),
      // ),
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: const BoxDecoration(
            boxShadow: [BoxShadows.shadows], color: Colors.white),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.mainColor,
          unselectedItemColor: AppColors.secondBlack,
          items: _navItems,
          onTap: _onNavItemTapped,
        ),
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

// class BarcodeScanScreen extends StatefulWidget {
//   const BarcodeScanScreen({super.key});

//   @override
//   State<BarcodeScanScreen> createState() => _BarcodeScanScreenState();
// }

// class _BarcodeScanScreenState extends State<BarcodeScanScreen> {
//   Future<void> scanBarcode(BuildContext context) async {
//     String barcodeScanRes;

//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//         '#ff6666',
//         'Cancel',
//         true,
//         ScanMode.BARCODE,
//       );
//       print('barcode data: $barcodeScanRes');

//       if (barcodeScanRes != '-1') {
//         if (barcodeScanRes != '-1') {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FakeProductScreen(barcode: barcodeScanRes),
//             ),
//           );
//         }
//         //navigate
//       }
//     } on PlatformException catch (e) {
//       if (e.code == 'USER_CANCELLED') {
//         print('Barcode scanning cancelled by user');
//       } else {
//         print('Failed to scan barcode: ${e.message}');
//       }
//     }
//   }

//   void _scan() async {
//     await scanBarcode(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: ElevatedButton(
//         onPressed: () {
//           _scan();
//         },
//         child: const Text('Баркод уншуулах'),
//       )),
//     );
//   }
// }
