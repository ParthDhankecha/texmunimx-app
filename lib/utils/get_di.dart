import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/controllers/login_controllers.dart';
import 'package:textile_po/controllers/splash_controller.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/repository/create_design_repo.dart';
import 'package:textile_po/repository/login_repo.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => Sharedprefs(pref: preferences));

  Get.lazyPut(() => ApiClient(baseUrl: AppConst.baseUrl, sp: Get.find()));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: Get.find()));
  Get.lazyPut(() => CreateDesignRepo());

  //controllers
  Get.lazyPut(() => SplashController(sp: Get.find()));
  Get.lazyPut(
    () => LoginControllers(
      sp: Get.find<Sharedprefs>(),
      repo: Get.find<LoginRepo>(),
    ),
  );
  Get.lazyPut(() => HomeController(sp: Get.find()));
  Get.lazyPut(() => CreateDesignController());
}
