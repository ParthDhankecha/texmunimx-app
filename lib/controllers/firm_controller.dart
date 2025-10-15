import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/firm_list_response.dart';
import 'package:texmunimx/models/roles_model.dart';
import 'package:texmunimx/models/user_list_response.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/firm_repository.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class FirmController extends GetxController implements GetxService {
  // User-related logic here
  final FirmRepository firmRepository = Get.find<FirmRepository>();
  final Sharedprefs sp = Get.find<Sharedprefs>();

  List<RolesModel> userRole = [];

  RxList<UserModel> users = <UserModel>[].obs;
  RxList<FirmModel> firms = <FirmModel>[].obs;

  RxBool isLoading = false.obs;

  getUserRolesById(int id) {
    return userRole.firstWhere((role) => role.id == id).type;
  }

  Future<void> fetchFirms() async {
    try {
      isLoading.value = true;
      firms.value = await firmRepository.fetchFirms();
    } on ApiException catch (e) {
      // Handle error
      showErrorSnackbar(e.message);
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  void createFirm({required String name}) async {
    try {
      isLoading.value = true;

      var body = {"firmName": name};
      await firmRepository.createFirm(body: body);
      fetchFirms();
      Get.back();
      showSuccessSnackbar('User created successfully');
    } on ApiException catch (e) {
      // Handle error
      showErrorSnackbar(e.message);
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  void updateFirm({required String firmId, required String name}) async {
    try {
      isLoading.value = true;

      var body = {"firmName": name};
      await firmRepository.updateFirm(firmId: firmId, body: body);
      fetchFirms();
      Get.back();
      showSuccessSnackbar('Firm updated successfully');
    } on ApiException catch (e) {
      // Handle error
      showErrorSnackbar(e.message);
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  void deleteFirm({required String firmId}) async {
    try {
      isLoading.value = true;

      await firmRepository.deleteFirm(firmId: firmId);

      Get.back();
      fetchFirms();
      showSuccessSnackbar('Firm deleted successfully');
    } on ApiException catch (e) {
      // Handle error
      showErrorSnackbar(e.message);
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }
}
