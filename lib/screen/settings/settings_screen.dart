import 'package:flutter/material.dart';
import 'package:shunhlai_attendance/app_types.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/globals.dart';
import 'package:shunhlai_attendance/models/employe_data_entity.dart';
import 'package:shunhlai_attendance/service/company_name_repo.dart';
import 'package:shunhlai_attendance/service/settings_repo.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final bool _refreshData = false;
  Future<void> logout() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    print('*** хэрэглэгч гарлаа');
    Navigator.pushReplacementNamed(
      context,
      RoutesName.login,
    );
  }

  CompanyNameRepository getcompany = CompanyNameRepository();

  @override
  void initState() {
    super.initState();
    getcompany.getCompanyName();
    // _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<EmployeeDataEntity?>(
        future: EmployeDataApiClient().getEmployeeData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show a loading indicator while fetching data.
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Интернэт холболтоо шалгана уу!',
                style: TextStyles.black16,
              ),
            );
          } else if (snapshot.hasData) {
            final employee = snapshot.data!;

            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expanded(
                      //     flex: 2,
                      //     child: Image.network(
                      //       employee.image1920.toString(),
                      //       fit: BoxFit.cover,
                      //     )),
                      Expanded(
                        flex: 3,
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              employee.name.toString(),
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              employee.jobTitle.toString(),
                              style: TextStyles.black16,
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.065,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.38,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.mainColor),
                      child: Column(
                        children: [
                          _buildRow(
                            Globals.getCompany(),
                            // 'IVCO',
                            'Компани',
                            const Icon(Icons.home, size: 30),
                          ),
                          _buildRow(
                            employee.mobilePhone.toString(),
                            // '99999999',
                            'Утасны дугаар',
                            const Icon(Icons.phone, size: 30),
                          ),
                          _buildRow(
                            employee.workEmail.toString(),
                            // 'email@ivco.mn',
                            'e-мэйл',
                            const Icon(Icons.email, size: 30),
                          ),
                          _buildRow(
                            employee.workLocation.toString(),
                            'Хаяг',
                            const Icon(Icons.location_city, size: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 0.10,
                  child: InkWell(
                    onTap: logout,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.mainColor,
                          boxShadow: const [BoxShadows.shadow3]),
                      child: const Center(
                        child: Text(
                          'Гарах',
                          style: TextStyles.white16semibold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 60,
                )
              ],
            );
          } else {
            return const Text('No employee data available');
          }
        },
      ),
    );
  }

  Widget _buildRow(String defualtText, String dynamicText, Icon icon) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.white),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: icon,
                )),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dynamicText,
                  style: TextStyles.white16semibold,
                ),
                Text(
                  defualtText,
                  style: TextStyles.white16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
