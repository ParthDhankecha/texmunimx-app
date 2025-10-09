import 'package:get/get.dart';
import 'package:textile_po/common_widgets/show_error_snackbar.dart';
import 'package:textile_po/common_widgets/show_success_snackbar.dart';
import 'package:textile_po/models/roles_model.dart';
import 'package:textile_po/models/user_list_response.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/users_repository.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/utils/shared_pref.dart';

class UserController extends GetxController implements GetxService {
  // User-related logic here
  final UsersRepository usersRepository = Get.find<UsersRepository>();
  final Sharedprefs sp = Get.find<Sharedprefs>();

  List<RolesModel> userRole = [];

  RxList<UserModel> users = <UserModel>[].obs;

  RxBool isLoading = false.obs;

  updateRoles() {
    if (userRole.isNotEmpty) {
      userRole = [];
    }
    userRole.add(RolesModel(id: sp.admin, type: 'ADMIN'));
    userRole.add(RolesModel(id: sp.manager, type: 'MANAGER'));
    userRole.add(RolesModel(id: sp.job, type: 'JOB'));
  }

  @override
  onInit() {
    super.onInit();
    updateRoles();
  }

  getUserRolesById(int id) {
    return userRole.firstWhere((role) => role.id == id).type;
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      users.value = await usersRepository.getAllUsers();
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

  void createUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required int role,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;

      var body = {
        "fullname": name,
        "mobile": phone,
        "email": email,
        "userType": role,
        "password": password,
        "isActive": isActive,
      };
      await usersRepository.createUser(body: body);
      fetchAllUsers();
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

  //update only active
  void updateUserActiveStatus({
    required String userId,
    required bool isActive,
    required int intdex,
  }) async {
    try {
      //  isLoading.value = true;
      await usersRepository.updateUserActiveStatus(
        userId: userId,
        isActive: isActive,
      );

      users[intdex].isActive = isActive;
      users.refresh();

      showSuccessSnackbar('User updated successfully');
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
      // isLoading.value = false;
    }
  }

  void updateUser({
    required String userId,
    required String name,
    required String email,
    required String phone,
    required String password,
    required int role,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;

      var body = {
        "fullname": name,
        "mobile": phone,
        "email": email,
        "userType": role,
        "password": password,
        "isActive": isActive,
      };
      await usersRepository.updateUser(userId: userId, body: body);
      fetchAllUsers();
      Get.back();
      showSuccessSnackbar('User updated successfully');
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

  void deleteUser({required String userId}) async {
    try {
      isLoading.value = true;

      await usersRepository.deleteUser(userId: userId);

      Get.back();
      fetchAllUsers();
      showSuccessSnackbar('User deleted successfully');
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
