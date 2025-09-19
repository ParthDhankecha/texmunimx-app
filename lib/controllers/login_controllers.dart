import 'dart:async';
import 'dart:developer';

import 'package:textile_po/common_widgets/show_error_snackbar.dart';
import 'package:textile_po/models/login_auth_model.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/login_repo.dart';
import 'package:textile_po/screens/auth_screens/verify_otp_screen.dart';
import 'package:textile_po/screens/home/home_screen.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';

class LoginControllers extends GetxController implements GetxService {
  RxString phone = ''.obs;
  RxString otp = ''.obs;
  RxBool isLoading = false.obs;

  Timer? _timer;
  int timerSeconds = 60; // Initial countdown duration
  RxBool canResend = false.obs;
  RxString remainingTimer = ''.obs;

  final LoginRepo repo;

  final Sharedprefs sp;

  LoginControllers({required this.sp, required this.repo});

  void setPhoneNumber(String num) {
    phone.value = num;
  }

  void setOtp(String num) {
    otp.value = num;
  }

  void setLoading(bool load) {
    isLoading.value = load;
  }

  sendOtp() async {
    try {
      isLoading.value = true;
      startTimer();
      otp.value = '';
      await repo.sendOtp(mobile: phone.value);
      Get.to(() => VerifyOtpScreen());
    } catch (e) {
      //print('send otp error : $e');
    } finally {
      isLoading.value = false;
    }
  }

  verifyOTP() async {
    try {
      isLoading.value = true;
      AuthData data = await repo.verifyOTP(mobile: phone.value, otp: otp.value);
      if (data.token.accessToken.isNotEmpty) {
        sp.userToken = data.token.accessToken;

        Get.offAll(() => HomeScreen());
      }
    } on ApiException catch (e) {
      log('Error : $e');
      showErrorSnackbar(
        'Invalid OTP code.',
        decs: 'Please check your Number and OTP code.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    canResend.value = false;
    timerSeconds = 60; // Reset timer
    remainingTimer.value = 'in ${timerSeconds}s';
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerSeconds == 0) {
        canResend.value = true;
        remainingTimer.value = '';
        _timer?.cancel();
      } else {
        timerSeconds--;
        remainingTimer.value = 'in ${timerSeconds}s';
      }
    });
  }

  void timerDispose() {
    _timer?.cancel();
  }
}
