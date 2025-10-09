import 'dart:convert';

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

  //create user
  Future<bool> createUser({required Map<String, dynamic> body}) async {
    var response = await apiClient.requestPost(
      AppConst.usersCreate,
      headers: {'authorization': sp.userToken},
      body: body,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }

  Future<bool> updateUser({
    required String userId,
    required Map<String, dynamic> body,
  }) async {
    var response = await apiClient.requestPut(
      '${AppConst.usersCreate}/$userId',
      headers: {'authorization': sp.userToken},
      body: body,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }

  Future<bool> updateUserActiveStatus({
    required String userId,
    required bool isActive,
  }) async {
    var response = await apiClient.requestPut(
      '${AppConst.usersCreate}/$userId',
      headers: {'authorization': sp.userToken},
      body: {'isActive': isActive},
    );
    var data = jsonDecode(response);
    return data['code'] == 'OK';
  }

  Future<bool> deleteUser({required String userId}) async {
    var response = await apiClient.request(
      '${AppConst.usersCreate}/$userId',
      headers: {'authorization': sp.userToken},
      method: ApiType.delete,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }
}
