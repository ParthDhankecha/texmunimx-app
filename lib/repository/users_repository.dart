import 'package:get/get.dart';
import 'package:textile_po/models/user_list_response.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class UsersRepository {
  Sharedprefs sp = Get.find<Sharedprefs>();
  ApiClient apiClient = Get.find<ApiClient>();

  //get all users

  Future<List<UserModel>> getAllUsers() async {
    var response = await apiClient.requestPost(
      AppConst.users,
      headers: {'authorization': sp.userToken},
    );

    List<UserModel> usersList = [];
    var useResponse = userListResponseFromMap(response);
    if (useResponse.code == 'OK') {
      usersList = useResponse.data.list;
    }

    return usersList;
  }
}
