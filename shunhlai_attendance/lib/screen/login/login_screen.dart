// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shunhlai_attendance/app_types.dart';
import 'package:shunhlai_attendance/components/custom_text_field.dart';
import 'package:shunhlai_attendance/constant/constant.dart';
import 'package:shunhlai_attendance/service/authentication.dart';
import 'package:shunhlai_attendance/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // TextEditingController ipController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService auth = AuthService();
  bool remember = false;
  RegExp pattern = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  @override
  void initState() {
    super.initState();
    loadSavedCredentials();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose;
    print('Dispose used');
    super.dispose();
  }

// нэвтрэх үйлдэл

  void main() async {
    if (remember == true) {
      saveCredentials();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    }

    final loggedIn = await auth.login(
        emailController.text, passwordController.text, context);
    if (loggedIn) {
      Utils.flushBarSuccessMessage('Амжилттай нэвтэрлээ', context);
      print('logged in successfully');
      Navigator.pushNamed(context, RoutesName.main);
    } else {
      print('login failed');
      Utils.flushBarErrorMessage(
          'Нэвтрэх нэр эсвэл нууц үг буруу байна.', context);
    }
  }

// хэрэглэгч нэр, нууц үг хадгалах

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', emailController.text);
    await prefs.setString('password', passwordController.text);
  }

// Санасан нэр,нууц үг шалгах

  Future<void> loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');

    setState(() {
      emailController.text = savedUsername ?? '';
      passwordController.text = savedPassword ?? '';

      remember = savedUsername != null && savedPassword != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    height: MediaQuery.of(context).size.height * 0.15,
                    image: const AssetImage(
                      'assets/logo.png',
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ],
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.07,
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // _buildIpField(),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  _buildEmailField(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildPasswordField(),
                  const SizedBox(
                    height: 20,
                  ),
                  _buldCheckBox(),
                  InkWell(
                    onTap: () {
                      // if (ipController.text.isEmpty) {
                      //   Utils.flushBarErrorMessage(
                      //       'Хандах хаяг оруулна уу', context);
                      // }
                      if (emailController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            'Нэвтрэх нэрээ оруулна уу', context);
                      } else if (passwordController.text.isEmpty) {
                        Utils.flushBarErrorMessage(
                            'Нууц үг оруулна уу', context);
                      } else if (passwordController.text.length < 3) {
                        Utils.flushBarErrorMessage(
                            '6 оронтой тоо оруулна уу', context);
                      } else {
                        main();
                        print('logged in');
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.065,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.mainColor),
                      child: const Center(
                        child: Text(
                          'Нэвтрэх',
                          style: TextStyles.white16semibold,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text('SHUNKHLAI LLC 2023'),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buldCheckBox() {
    return Row(
      children: [
        Checkbox(
          value: remember,
          tristate: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onChanged: (newValue) {
            setState(() {
              remember = newValue ?? false;
            });
          },
        ),
        const Text('Хэрэглэгч сануулах'),
      ],
    );
  }

  CustomTextField _buildPasswordField() {
    return CustomTextField(
      baseColor: AppColors.secondBlack,
      borderColor: AppColors.mainColor,
      controller: passwordController,
      errorColor: Colors.red,
      hint: 'Нууц үг',
      obscureText: true,
    );
  }

  CustomTextField _buildEmailField() {
    return CustomTextField(
      baseColor: AppColors.secondBlack,
      borderColor: AppColors.mainColor,
      controller: emailController,
      errorColor: Colors.red,
      hint: 'Нэвтрэх нэр',
    );
  }
}
