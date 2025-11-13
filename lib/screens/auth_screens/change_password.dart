import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:texmunimx/common_widgets/main_btn.dart';
import 'package:texmunimx/common_widgets/password_input.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/controllers/login_controllers.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();

  LoginControllers loginController = Get.find<LoginControllers>();

  @override
  initState() {
    super.initState();
    loginController.oldPasswordCont.text = '';
    loginController.newPasswordCont.text = '';
    loginController.confirmPasswordCont.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('change_password'.tr),
        centerTitle: true,
        // backgroundColor: AppColors.appBg,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('old_password'.tr, style: bodyStyle),
                  SizedBox(height: 8),
                  PasswordTextField(
                    controller: loginController.oldPasswordCont,
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
                  SizedBox(height: 16),
                  Text('new_password'.tr, style: bodyStyle),
                  SizedBox(height: 8),

                  PasswordTextField(
                    controller: loginController.newPasswordCont,
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
                  SizedBox(height: 16),
                  Text('confirm_password'.tr, style: bodyStyle),
                  SizedBox(height: 8),
                  PasswordTextField(
                    controller: loginController.confirmPasswordCont,
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
                            label: 'change_password'.tr,
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                if (loginController.newPasswordCont.text ==
                                    loginController.confirmPasswordCont.text) {
                                  loginController.changePassword();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                } else {
                                  showErrorSnackbar(
                                    'Passwords and Confirm Password do not match',
                                  );
                                }
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
    );
  }
}
