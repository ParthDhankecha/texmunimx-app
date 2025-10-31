import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/main_btn.dart';
import 'package:texmunimx/common_widgets/password_input.dart';
import 'package:texmunimx/controllers/login_controllers.dart';
import 'package:texmunimx/screens/auth_screens/widgets/privacy_bar.dart';
import 'package:get/get.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  LoginControllers loginController = Get.find<LoginControllers>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logoHero',
                  child: SizedBox(
                    height: 130,

                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: Image.asset(
                              'assets/images/logo_tr.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            AppStrings.appName,
                            style: titleStyle.copyWith(
                              fontSize: 20,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'login_with_username_and_password'.tr,
                  style: headingStyle,
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('email'.tr, style: bodyStyle),
                      SizedBox(height: 8),
                      InputField(
                        textEditingController: loginController.emailCont,

                        hintText: 'Enter your email',
                        textInputType: TextInputType.emailAddress,
                        onValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // // Simple email validation
                          // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          //   return 'Please enter a valid email address';
                          // }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('password'.tr, style: bodyStyle),
                      SizedBox(height: 8),
                      PasswordTextField(
                        controller: loginController.passwordCont,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Obx(
                        () => loginController.isLoading.value
                            ? CustomProgressBtn()
                            : MainBtn(
                                label: 'Login',
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    // Call login function
                                    loginController.loginWithEmailPassword();
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(bottom: 16, left: 0, right: 0, child: PrivacyBar()),
        ],
      ),
    );
  }
}
