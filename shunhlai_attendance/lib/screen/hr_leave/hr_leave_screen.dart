import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/screen/hr_leave/hr_leave_list_screen.dart';
import 'package:shunhlai_attendance/service/hr_leave_type_repo.dart';
import 'package:shunhlai_attendance/service/hr_leave_udruur_repo.dart';

class HrLeaveScreen extends StatefulWidget {
  const HrLeaveScreen({
    super.key,
    required this.context,
  });

  final BuildContext context;

  @override
  State<HrLeaveScreen> createState() => _HrLeaveScreenState();
}

class _HrLeaveScreenState extends State<HrLeaveScreen> {
  HrLeaveUdruur udruur = HrLeaveUdruur();
  HrLeaveTsagaar tsagaar = HrLeaveTsagaar();
  List<Temperatures> data = [];
  final HrLeaveTypeApiClient _apiClient = HrLeaveTypeApiClient();
  final TextEditingController _controller = TextEditingController();
  List<Temperatures> _leaveTypes = [];

  String chosenOne = 'employee';
  String chosenOne1 = '0';
  String chosenOne2 = '0';
  bool byHour = false;
  int daysDifference = 0;

  int? _selectedValue;
  late String _selectedHoliday = '';

  String selectedItem = 'Ажилтнаар';

  List<String> dropdownItems = [
    'Ажилтнаар',
    'Компаниар',
    'Хэлтэс',
    'Ажилчны пайзаар'
  ];
  @override
  void initState() {
    super.initState();
    hhh();
    fetchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hhh();
      });
    }
  }

  void hhh() {
    // Assuming selectedDate and selectedDate2 are DateTime objects
    daysDifference = selectedDate2.difference(selectedDate).inDays + 1;

    // Now you have the difference in days
    print(
        'Number of days between $selectedDate and $selectedDate2: $daysDifference days');

    // If you need to use this value in the UI, you can update the state using setState
    setState(() {
      // Update any state variable with the calculated daysDifference
      // For example: this.daysDifference = daysDifference;
    });
  }

  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate2) {
      setState(() {
        selectedDate2 = picked;
        hhh();
      });
    }
  }

  Future<void> fetchData() async {
    try {
      List<Temperatures> fetchedData = await _apiClient.fetchData();
      setState(() {
        _leaveTypes = fetchedData;
      });
    } catch (error) {
      // Handle error
      print('Error: $error');
    }
  }

  double num1 = 0.0;
  double num2 = 0.0;
  // double num1 = double.parse(chosenOne1);
  // double num2 = double.parse(chosenOne2);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedDate2 = DateFormat('yyyy-MM-dd').format(selectedDate2);

    return Scaffold(
      appBar: AppBar(),
      body: byHour
          ? _tsagaar(context, formattedDate, formattedDate2)
          : _udruur(context, formattedDate, formattedDate2),
    );
  }

  Padding _tsagaar(
      BuildContext context, String formattedDate, String formattedDate2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          InkWell(onTap: () {}, child: _buildTitle('Төрөл')),
          _dropDown(context),
          _dropdowns(context),
          _hourDropDown(context),
          _buildTitle('Үргэлжлэх хугацаа'),
          _buildUrgeljlehHugatsaa('${num2 - num1} '),
          _datePicker(context, formattedDate, formattedDate2),
          _buildTitle('Тайлбар'),
          _buildTailbar(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                print(_selectedValue);
                tsagaar.create(
                    _controller.text,
                    Globals.getEmployeeId(),
                    Globals.getDepartmentId(),
                    chosenOne1,
                    chosenOne2,
                    true,
                    _selectedValue as int,
                    formattedDate,
                    formattedDate2,
                    chosenOne,
                    'confirm',
                    num2 - num1);
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HrLeaveListScreen()),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.mainColor,
                    boxShadow: const [BoxShadows.shadow2]),
                child: const Center(
                  child: Text(
                    'Илгээх',
                    style: TextStyles.white14semibold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 500,
          ),
        ],
      ),
    );
  }

  Padding _udruur(
      BuildContext context, String formattedDate, String formattedDate2) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView(
        children: [
          _buildTitle('Төрөл'),
          _dropDown(context),
          _dropdowns(context),
          _datePicker(context, formattedDate, formattedDate2),
          _buildTitle('Үргэлжлэх хугацаа'),
          InkWell(
              onTap: () {
                hhh();
              },
              child: _buildUrgeljlehHugatsaa(
                formattedDate == formattedDate2
                    ? daysDifference.toString()
                    : '${daysDifference + 0}',
              )),
          _buildTitle('Тайлбар'),
          _buildTailbar(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                print(_selectedValue);
                udruur.create(
                  Globals.getDepartmentId(),
                  Globals.getEmployeeId(),
                  _selectedValue as int,
                  chosenOne,
                  _controller.text,
                  formattedDate,
                  formattedDate2,
                  'confirm',
                  daysDifference.toDouble(),
                );
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HrLeaveListScreen()),
                );
              },
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.mainColor,
                    boxShadow: const [BoxShadows.shadow2]),
                child: const Center(
                  child: Text(
                    'Илгээх',
                    style: TextStyles.white14semibold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 500,
          )
        ],
      ),
    );
  }

  Padding _dropdowns(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            underline: Container(),
            value: selectedItem,
            items: dropdownItems.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      item,
                      style: TextStyles.black14,
                    )),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem = newValue!;
                chosenOne = serverValues[dropdownItems.indexOf(selectedItem)];
              });
            },
          ),
        ),
      ),
    );
  }

  Padding _dropdowns1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            underline: Container(),
            value: selectedItem1,
            items: dropdownItems1.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      item,
                      style: TextStyles.black14,
                    )),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem1 = newValue!;
                chosenOne1 =
                    serverValues1[dropdownItems1.indexOf(selectedItem1)];
                num1 = double.parse(chosenOne1);
              });
            },
          ),
        ),
      ),
    );
  }

  Padding _dropdowns2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton(
            underline: Container(),
            value: selectedItem2,
            items: dropdownItems2.map((String item) {
              return DropdownMenuItem(
                value: item,
                child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      item,
                      style: TextStyles.black14,
                    )),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedItem2 = newValue!;
                chosenOne2 =
                    serverValues2[dropdownItems2.indexOf(selectedItem2)];
                num2 = double.parse(chosenOne2);
              });
            },
          ),
        ),
      ),
    );
  }

  Padding _buildUrgeljlehHugatsaa(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              text,
              style: TextStyles.black14,
            )),
      ),
    );
  }

  Padding _buildTailbar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.white,
            boxShadow: const [BoxShadows.shadow3]),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration.collapsed(
                hintText: 'Тайлбар', hintStyle: TextStyle(fontSize: 14)),
          ),
        ),
      ),
    );
  }

  Padding _datePicker(
      BuildContext context, String formattedDate, String formattedDate2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Хаанаас:'),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                      boxShadow: const [BoxShadows.shadow3]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '  $formattedDate',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.edit)
                    ],
                  ),
                ),
              ),
            ],
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Хүртэл:'),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  _selectDate2(context);

                  setState(() {});
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                      boxShadow: const [BoxShadows.shadow3]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '  $formattedDate2',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const Icon(Icons.edit)
                    ],
                  ),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  Padding _hourDropDown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Эхлэг цаг:'),
              const SizedBox(
                height: 10,
              ),
              _dropdowns1(context),
            ],
          )),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildTitle('Дуусах цаг:'),
              const SizedBox(
                height: 10,
              ),
              _dropdowns2(context),
            ],
          )),
        ],
      ),
    );
  }

  Padding _buildTitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyles.black14semibold,
      ),
    );
  }

  Padding _dropDown(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
          boxShadow: const [BoxShadows.shadow3],
        ),
        child: Center(
          child: DropdownButton<int>(
            value: _selectedValue,
            onChanged: (int? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedValue = newValue;
                });
              }

              Temperatures selectedLeaveType = _leaveTypes.firstWhere(
                (leaveType) => leaveType.id == newValue,
                orElse: () =>
                    Temperatures(id: 0, name: 'Unknown', requestUnit: null),
              );
              _selectedHoliday = selectedLeaveType.name!;

              _printRequestUnit(selectedLeaveType);
              if (selectedLeaveType.requestUnit == 'day') {
                byHour = false;
                setState(() {});
              } else {
                byHour = true;
                setState(() {});
              }

              setState(() {});
            },
            items: _leaveTypes.map((Temperatures leaveType) {
              return DropdownMenuItem<int>(
                value: leaveType.id,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    leaveType.name.toString(),
                    style: TextStyles.black14,
                  ),
                ),
              );
            }).toList(),
            underline: Container(),
          ),
        ),
      ),
    );
  }

  void _printRequestUnit(Temperatures leaveType) {
    if (leaveType.requestUnit == 'day') {
      byHour = false;
      setState(() {});
    } else {
      byHour = true;
      setState(() {});
    }
  }

  List<String> serverValues = ['employee', 'company', 'department', 'category'];
  String selectedItem1 = '12:00 AM';
  String selectedItem2 = '12:00 AM';

  List<String> dropdownItems1 = [
    '12:00 AM',
    '00:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '00:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
  ];
  List<String> serverValues1 = [
    '0',
    '0.5',
    '1',
    '1.5'
        '2',
    '2.5',
    '3',
    '3.5',
    '4',
    '4.5',
    '5',
    '5.5',
    '6',
    '6.5',
    '7',
    '7.5',
    '8',
    '8.5',
    '9',
    '9.5',
    '10',
    '10.5',
    '11',
    '11.5',
    '12',
    '12.5',
    '13',
    '13.5'
        '14',
    '14.5',
    '15',
    '15.5',
    '16',
    '16.5',
    '17',
    '17.5',
    '18',
    '18.5'
        '19',
    '19.5',
    '20',
    '20.5',
    '21',
    '21.5',
    '22',
    '22.5',
    '23',
    '23.5',
  ];
  List<String> dropdownItems2 = [
    '12:00 AM',
    '00:30 AM',
    '01:00 AM',
    '01:30 AM',
    '02:00 AM',
    '02:30 AM',
    '03:00 AM',
    '03:30 AM',
    '04:00 AM',
    '04:30 AM',
    '05:00 AM',
    '05:30 AM',
    '06:00 AM',
    '06:30 AM',
    '07:00 AM',
    '07:30 AM',
    '08:00 AM',
    '08:30 AM',
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '00:30 PM',
    '01:00 PM',
    '01:30 PM',
    '02:00 PM',
    '02:30 PM',
    '03:00 PM',
    '03:30 PM',
    '04:00 PM',
    '04:30 PM',
    '05:00 PM',
    '05:30 PM',
    '06:00 PM',
    '06:30 PM',
    '07:00 PM',
    '07:30 PM',
    '08:00 PM',
    '08:30 PM',
    '09:00 PM',
    '09:30 PM',
    '10:00 PM',
    '10:30 PM',
    '11:00 PM',
    '11:30 PM',
  ];
  List<String> serverValues2 = [
    '0',
    '0.5',
    '1',
    '1.5'
        '2',
    '2.5',
    '3',
    '3.5',
    '4',
    '4.5',
    '5',
    '5.5',
    '6',
    '6.5',
    '7',
    '7.5',
    '8',
    '8.5',
    '9',
    '9.5',
    '10',
    '10.5',
    '11',
    '11.5',
    '12',
    '12.5',
    '13',
    '13.5'
        '14',
    '14.5',
    '15',
    '15.5',
    '16',
    '16.5',
    '17',
    '17.5',
    '18',
    '18.5'
        '19',
    '19.5',
    '20',
    '20.5',
    '21',
    '21.5',
    '22',
    '22.5',
    '23',
    '23.5',
  ];
}
