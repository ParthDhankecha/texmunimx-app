import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/login_repo.dart';
import 'package:texmunimx/repository/users_repository.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/screens/home/home_screen.dart';
import 'package:texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController implements GetxService {
  RxString phone = ''.obs;
  RxString otp = ''.obs;
  RxBool isLoading = false.obs;

  final LoginRepo repo;

  final Sharedprefs sp;

  RxInt selectedRole = 3.obs;

  //input controllers
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  LoginControllers({required this.sp, required this.repo});

  UsersRepository usersRepo = Get.find<UsersRepository>();

  void changePassword() async {
    try {
      isLoading.value = true;

      String oldPassword = oldPasswordCont.text.trim();
      String newPassword = newPasswordCont.text.trim();
      var data = await usersRepo.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      if (data) {
        Get.back();
        showSuccessSnackbar('Password changed successfully');
      }
    } on ApiException catch (e) {
      log('Change Password Error : $e');
      if (e.message.isNotEmpty) {
        Get.snackbar(
          e.message,
          '',

          messageText: Container(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void setLoading(bool load) {
    isLoading.value = load;
  }

  loginWithEmailPassword() async {
    try {
      isLoading.value = true;
      String userEmail = emailCont.text.trim();
      String userPassword = passwordCont.text.trim();

      var data = await repo.loginWithEmailPassword(
        email: userEmail,
        password: userPassword,
      );

      log('login response :::');

      log(data.token.accessToken);
      if (data.token.accessToken.isNotEmpty) {
        sp.userToken = data.token.accessToken;
        sp.userRole = data.user.type;
        selectedRole.value = data.user.type;

        log('User Role : ${sp.userRole}');
        Get.offAll(() => HomeScreen());
      } else {}
    } on ApiException catch (e) {
      log('Login Error : $e');
      if (e.message.isNotEmpty) {
        Get.snackbar(
          e.message,
          '',

          messageText: Container(),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    sp.clearAll();
    Get.offAll(() => LoginScreen());
  }
}
