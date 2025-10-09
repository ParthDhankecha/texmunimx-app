import 'dart:convert';
import 'dart:developer';

import 'package:textile_po/common_widgets/show_error_snackbar.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/screens/home/home_screen.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final Sharedprefs sp;

  SplashController({required this.sp});

  final RxBool isLoading = false.obs;
  final ApiClient apiClient = Get.find<ApiClient>();

  checkUser() {
    Future.delayed(Duration(seconds: 2), () {
      if (sp.userToken.isNotEmpty) {
        Get.offAll(() => HomeScreen());
      } else {
        Get.off(() => LoginScreen());
      }
    });
  }

  getDEfaultConfig() async {
    try {
      var response = await apiClient.request(AppConst.defaultConfig);
      var data = jsonDecode(response);
      String placeHolderImg = data['data']['placeHolderImg'] ?? '';
      String publicUrl = data['data']['publicUrl'] ?? '';

      Map<String, dynamic> userRoles = data['data']['roles'] ?? {};
      sp.owner = userRoles['OWNER'] ?? 1;
      sp.admin = userRoles['ADMIN'] ?? 2;
      sp.manager = userRoles['MANAGER'] ?? 3;
      sp.job = userRoles['JOB'] ?? 4;

      AppConst.placeHolderImage = placeHolderImg;
      AppConst.imageBaseUrl = publicUrl;
      checkUser();
    } on ApiException catch (e) {
      log('error : $e');

      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
          showErrorSnackbar(
            'Unable to connect with Server.',
            decs: 'Check your Internet connection and Restart App',
          );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
