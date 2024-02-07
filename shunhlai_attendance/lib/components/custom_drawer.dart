import 'package:flutter/material.dart';
import 'package:shunhlai_attendance/app_types.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/screen/hr_leave/hr_leave_list_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void hrLeave() {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const HrLeaveListScreen()));
    }

    return Drawer(
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.6,
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.only(
      //       bottomLeft: Radius.circular(100), topLeft: Radius.circular(0)),
      // ),
      backgroundColor: AppColors.secondBlack,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          // const DrawerHeader(
          //   curve: Curves.easeIn,
          //   decoration: BoxDecoration(
          //     color: AppColors.secondBlack,
          //   ),
          //   child: Text(
          //     'Цэс',
          //     style: TextStyles.white16semibold,
          //   ),
          // ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            title: const Text(
              'Ирц харах',
              style: TextStyles.white16,
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutesName.attendanceScreen);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.calendar_month,
              color: Colors.white,
            ),
            title: const Text(
              'Чөлөө',
              style: TextStyles.white16,
            ),
            onTap: () {
              hrLeave();
            },
          ),
          // if (Globals.getIsStockUser() == true)
          //   ListTile(
          //     leading: const Icon(
          //       Icons.calendar_month,
          //       color: Colors.white,
          //     ),
          //     title: const Text(
          //       'Тооллого',
          //       style: TextStyles.white16,
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, RoutesName.countScreen);
          //     },
          //   )
          // else if (Globals.getIsStockAdmin() == true)
          //   ListTile(
          //     leading: const Icon(
          //       Icons.calendar_month,
          //       color: Colors.white,
          //     ),
          //     title: const Text(
          //       'Тооллого',
          //       style: TextStyles.white16,
          //     ),
          //     onTap: () {
          //       Navigator.pushNamed(context, RoutesName.countScreen);
          //     },
          //   )
          // else
          //   const SizedBox(),
          // ListTile(
          //   leading: const Icon(
          //     Icons.calendar_month,
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     'Бараа',
          //     style: TextStyles.white16,
          //   ),
          //   onTap: () {
          //     Navigator.pushNamed(context, RoutesName.productScreen);
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.calendar_month,
          //     color: Colors.white,
          //   ),
          //   title: const Text(
          //     'цалин',
          //     style: TextStyles.white16,
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (_) => const SalaryScreen()));
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.train,
          //   ),
          //   title: const Text(
          //     'test',
          //     style: TextStyles.black19,
          //   ),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (_) => const TestProduct()));
          //   },
          // ),
        ],
      ),
    );
  }
}
