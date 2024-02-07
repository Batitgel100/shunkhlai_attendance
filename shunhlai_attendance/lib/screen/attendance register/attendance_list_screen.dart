import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shunhlai_attendance/components/custom_indicator.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/attendince_list_entity.dart';
import 'package:shunhlai_attendance/service/attendance_list_repo.dart';

class AttendanceListScreen extends StatefulWidget {
  const AttendanceListScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceListScreen> createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  List<AttendanceListEntity> attendanceList = [];
  List<AttendanceListEntity> filteredAttendanceList = [];
  bool isloading = true;

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    try {
      final data = await AttendanceListApiClient().fetchData();
      setState(() {
        attendanceList = data;
        filteredAttendanceList = data;
        isloading = false;
      });
    } catch (e) {
      // Handle errors
    }
  }

  void filterAttendanceData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredAttendanceList = attendanceList;
      });
    } else {
      setState(() {
        filteredAttendanceList = attendanceList.where((attendance) {
          return attendance.checkIn!.contains(query);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(''),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 30,
          ),
        ),
      ),
      body: isloading
          ? const CustomProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: AppColors.secondBlack, width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: TextField(
                              onChanged: (query) {
                                // Call a function to filter the data based on the search query.
                                filterAttendanceData(query);
                              },
                              decoration: const InputDecoration.collapsed(
                                hintText: 'Хайлт хийх',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Scrollbar(
                      thickness: 7,
                      radius: const Radius.circular(12),
                      thumbVisibility: true,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        itemCount: filteredAttendanceList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final record = filteredAttendanceList[index];
                          return _buildCard(
                            record.checkIn.toString(),
                            'Ирсэн -',
                            'Явсан -',
                            record.checkOut.toString(),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Padding _buildCard(
    String cameDay,
    String textcame,
    String textgone,
    String? goneHour,
  ) {
    String? formatDateTime(String? dateTimeString) {
      if (dateTimeString == null) {
        textgone = '';
        return 'Бүртгээгүй';
      }

      try {
        final DateTime parsedDateTime = DateTime.parse(dateTimeString).add(
          const Duration(hours: 8),
        );

        final formattedTime = DateFormat('HH:mm:ss').format(parsedDateTime);
        return formattedTime;
      } catch (e) {
        return 'Invalid date format'; // Return an error message if parsing fails
      }
    }

    final formattedDateTime = DateFormat('yyyy-M-d').format(
      DateTime.parse(cameDay).add(
        const Duration(hours: 8),
      ),
    );
    final formattedTime = DateFormat('HH:mm:ss').format(
      DateTime.parse(cameDay).add(
        const Duration(hours: 8),
      ),
    );

    String? formattedGone =
        goneHour != null.toString() ? formatDateTime(goneHour) : 'Бүртгээгүй';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                height: 40,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.secondBlack),
                child: Center(
                  child: Text(
                    formattedDateTime,
                    style: TextStyles.white16semibold,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: .0),
                      child: Text(
                        '$textcame $formattedTime',
                        style: TextStyles.black14,
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      child: Text(
                        '$textgone ${formattedGone!}',
                        style: TextStyles.black14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
