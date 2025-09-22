import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/controllers/localization_controller.dart';
import 'package:textile_po/controllers/login_controllers.dart';
import 'package:textile_po/controllers/party_controller.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/controllers/splash_controller.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/repository/create_design_repo.dart';
import 'package:textile_po/repository/login_repo.dart';
import 'package:textile_po/repository/party_repo.dart';
import 'package:textile_po/repository/purchase_order_repository.dart';
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
  Get.lazyPut(() => PartyRepo());
  Get.lazyPut(() => PurchaseOrderRepository());

  //language
  Get.lazyPut(() => LocalizationController());

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
  Get.lazyPut(() => PartyController());
  Get.lazyPut(() => PurchaseOrderController());
}
