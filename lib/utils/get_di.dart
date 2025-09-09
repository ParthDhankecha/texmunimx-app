import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/controllers/login_controllers.dart';
import 'package:textile_po/controllers/splash_controller.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/repository/login_repo.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  ApiClient apiClient = ApiClient(baseUrl: AppConst.baseUrl);

  Get.lazyPut(() => Sharedprefs(pref: preferences));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: apiClient));

  //controllers
  Get.lazyPut(() => SplashController(sp: Get.find()));
  Get.lazyPut(
    () => LoginControllers(
      sp: Get.find<Sharedprefs>(),
      repo: Get.find<LoginRepo>(),
    ),
  );
  Get.lazyPut(() => HomeController(sp: Get.find()));
}
