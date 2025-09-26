import 'package:get/get.dart';
import 'package:textile_po/common_widgets/show_error_snackbar.dart';
import 'package:textile_po/models/user_list_response.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/users_repository.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';

class UserController extends GetxController implements GetxService {
  // User-related logic here
  final UsersRepository usersRepository = Get.find<UsersRepository>();

  RxList<UserModel> users = <UserModel>[].obs;

  RxBool isLoading = false.obs;

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
}
