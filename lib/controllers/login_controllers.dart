import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/login_repo.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/screens/home/home_screen.dart';
import 'package:textile_po/utils/shared_pref.dart';
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

  LoginControllers({required this.sp, required this.repo});

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
