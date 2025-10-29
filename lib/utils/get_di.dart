import 'package:texmunimx/controllers/app_update_controller.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/controllers/create_design_controller.dart';
import 'package:texmunimx/controllers/firm_controller.dart';
import 'package:texmunimx/controllers/home_controller.dart';
import 'package:texmunimx/controllers/localization_controller.dart';
import 'package:texmunimx/controllers/login_controllers.dart';
import 'package:texmunimx/controllers/party_controller.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/controllers/splash_controller.dart';
import 'package:texmunimx/controllers/user_controller.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/repository/calculator_repo.dart';
import 'package:texmunimx/repository/create_design_repo.dart';
import 'package:texmunimx/repository/firm_repository.dart';
import 'package:texmunimx/repository/login_repo.dart';
import 'package:texmunimx/repository/party_repo.dart';
import 'package:texmunimx/repository/purchase_order_repository.dart';
import 'package:texmunimx/repository/users_repository.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/my_theme_controller.dart';
import 'package:texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  Get.lazyPut(() => ThemeController());

  SharedPreferences preferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => Sharedprefs(pref: preferences));

  Get.lazyPut(() => ApiClient(baseUrl: AppConst.baseUrl, sp: Get.find()));

  //repository
  Get.lazyPut(() => LoginRepo(apiClient: Get.find()));
  Get.lazyPut(() => CreateDesignRepo());
  Get.lazyPut(() => PartyRepo());
  Get.lazyPut(() => PurchaseOrderRepository());
  Get.lazyPut(() => CalculatorRepo());
  Get.lazyPut(() => UsersRepository());
  Get.lazyPut(() => FirmRepository());

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
  Get.lazyPut(() => CalculatorController());
  Get.lazyPut(() => UserController());
  Get.lazyPut(() => FirmController());
  Get.lazyPut(() => AppUpdateController());
}
