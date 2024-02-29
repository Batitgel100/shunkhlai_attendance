import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shunhlai_attendance/components/custom_indicator.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/hr_leave_entity.dart';
import 'package:shunhlai_attendance/screen/hr_leave/hr_leave_screen.dart';
import 'package:shunhlai_attendance/service/hr_leave_list.dart';

class HrLeaveListScreen extends StatefulWidget {
  const HrLeaveListScreen({super.key});

  @override
  State<HrLeaveListScreen> createState() => _HrLeaveListScreenState();
}

class _HrLeaveListScreenState extends State<HrLeaveListScreen> {
  HrLeaveListApiClient fetchList = HrLeaveListApiClient();
  List<HrLeaveEntity> _leaveTypes = [];
  bool isloading = true;
  final TextEditingController _searchController = TextEditingController();
  List<HrLeaveEntity> _filteredLeaveTypes = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      List<HrLeaveEntity> fetchedData = await fetchList.fetchData();
      // fetchedData.sort((a, b) =>
      //     b.requestDateFrom!.compareTo(a.requestDateFrom as DateTime));
      setState(() {
        _leaveTypes = fetchedData;
        _filteredLeaveTypes = _leaveTypes; // Initialize filtered list
        isloading = false;
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  void _filterSearchResults(String query) {
    List<HrLeaveEntity> searchList = _leaveTypes.where((leave) {
      String formattedDateFrom =
          DateFormat('yyyy-MM-dd').format(leave.requestDateFrom as DateTime);
      return formattedDateFrom.contains(query);
    }).toList();
    setState(() {
      _filteredLeaveTypes = searchList;
    });
  }

  void fetch() {
    fetchList.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Container(
          // width: MediaQuery.of(con .text).size.width * 0.5,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: AppColors.mainColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _filterSearchResults(value);
              },
              decoration: const InputDecoration(
                hintText: 'Огноогоор хайх...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color.fromARGB(255, 117, 119, 118)),
              ),
              style: TextStyles.black14,
            ),
          ),
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          print(Globals.getCompanyId());
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => HrLeaveScreen(context: context)));
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.065,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.mainColor,
              boxShadow: const [BoxShadows.shadow3]),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Үүсгэх',
                style: TextStyles.white16,
              ),
            ],
          ),
        ),
      ),
      body: isloading
          ? const CustomProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredLeaveTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = _filteredLeaveTypes[index];
                      String formattedDatefrom = DateFormat('yyyy-MM-dd')
                          .format(item.requestDateFrom as DateTime);
                      String formattedDateTo = DateFormat('yyyy-MM-dd')
                          .format(item.requestDateTo as DateTime);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HrLeaveDetailScreen(
                                        employeeName:
                                            item.employeeId!.name.toString(),
                                        start: formattedDatefrom,
                                        end: formattedDateTo,
                                        type: item.holidayStatusId!.name
                                            .toString(),
                                        department:
                                            item.departmentId!.name.toString(),
                                        startHour:
                                            item.requestHourFrom.toString(),
                                        endHour: item.requestHourTo.toString(),
                                        tailbar: item.name.toString())));
                          },
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: const [BoxShadows.shadow3]),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildItem(
                                          'Ажилтны нэр',
                                          item.employeeId!.name.toString(),
                                        ),
                                        _buildItem(
                                          'Эхэлсэн огноо',
                                          formattedDatefrom,
                                        ),
                                        _buildItem(
                                          'Дууссан огноо',
                                          formattedDateTo,
                                        ),
                                        _buildItem(
                                          'Төрөл',
                                          item.holidayStatusId!.name.toString(),
                                        ),
                                        _buildItem(
                                          'Хэлтэс',
                                          item.departmentId!.name.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _buildStateItem(
                                    'Төлөв',
                                    item.state.toString() == 'confirm'
                                        ? 'Батлах ёстой'
                                        : item.state.toString() == 'draft'
                                            ? 'Илгээх'
                                            : item.state.toString() == 'refuse'
                                                ? 'Татгалзсан'
                                                : item.state.toString() ==
                                                        'cancel'
                                                    ? 'Цуцлагдсан'
                                                    : item.state.toString() ==
                                                            'validate'
                                                        ? 'Зөвшөөрөл'
                                                        : item.state.toString() ==
                                                                'validate1'
                                                            ? '2 дахь зөвшөөрөл'
                                                            : '',
                                  ),
                                ],
                              )),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }

  Container _buildItem(
    String type,
    String name,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              type,
              style: TextStyles.black14semibold,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              name,
              style: TextStyles.black14,
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildStateItem(
    String type,
    String name,
  ) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                type,
                style: TextStyles.white14semibold,
              ),
            ),
            Expanded(
              child: Text(
                name,
                style: TextStyles.white14semibold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HrLeaveDetailScreen extends StatefulWidget {
  final String employeeName;
  final String start;
  final String end;
  final String type;
  final String department;
  final String startHour;
  final String endHour;
  final String tailbar;
  const HrLeaveDetailScreen(
      {super.key,
      required this.employeeName,
      required this.start,
      required this.end,
      required this.type,
      required this.department,
      required this.startHour,
      required this.endHour,
      required this.tailbar});

  @override
  State<HrLeaveDetailScreen> createState() => _HrLeaveDetailScreenState();
}

class _HrLeaveDetailScreenState extends State<HrLeaveDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: const [BoxShadows.shadow3]),
          child: widget.startHour == 'null'
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItem('Ажилтны нэр', widget.employeeName),
                    _buildItem('Хэлтэс', widget.department),
                    _buildItem('Чөлөөний төрөл', widget.type),
                    _buildItem('Эхлэх огноо', widget.start),
                    _buildItem('Дуусах огноо', widget.end),
                    // widget.startHour == 'null'

                    _buildItem('Тайлбар',
                        widget.tailbar == 'null' ? 'Хоосон' : widget.tailbar),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildItem('Ажилтны нэр', widget.employeeName),
                    _buildItem('Хэлтэс', widget.department),
                    _buildItem('Чөлөөний төрөл', widget.type),
                    _buildItem('Эхлэх огноо', widget.start),
                    _buildItem('Дуусах огноо', widget.end),
                    _buildItem('Эхлэх цаг', widget.startHour),
                    _buildItem('Дуусах цаг', widget.endHour),
                    _buildItem('Тайлбар',
                        widget.tailbar == 'null' ? 'Хоосон' : widget.tailbar),
                  ],
                ),
        ),
      ),
    );
  }

  Container _buildItem(
    String type,
    String name,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              type,
              style: TextStyles.black14semibold,
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: TextStyles.black14,
            ),
          ),
        ],
      ),
    );
  }
}
