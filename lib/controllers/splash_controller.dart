import 'package:textile_po/screens/home/home_screen.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  final Sharedprefs sp;

  SplashController({required this.sp});

  checkUser() {
    Future.delayed(Duration(seconds: 2), () {
      if (sp.userToken.isNotEmpty) {
        Get.offAll(() => HomeScreen());
      }
    });
  }
}
