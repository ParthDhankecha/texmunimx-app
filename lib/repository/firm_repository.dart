import 'dart:convert';

import 'package:get/get.dart';
import 'package:texmunimx/models/firm_list_response.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class FirmRepository {
  Sharedprefs sp = Get.find<Sharedprefs>();
  ApiClient apiClient = Get.find<ApiClient>();

  //get all users

  Future<List<FirmModel>> fetchFirms() async {
    var response = await apiClient.requestPost(
      AppConst.firmsList,
      headers: {'authorization': sp.userToken},
    );

    List<FirmModel> firmsList = [];
    var firmResponse = firmListResponseFromMap(response);
    if (firmResponse.code == 'OK') {
      firmsList = firmResponse.data;
    }

    return firmsList;
  }

  //create firm
  Future<bool> createFirm({required Map<String, dynamic> body}) async {
    var response = await apiClient.requestPost(
      AppConst.firmsCreate,
      headers: {'authorization': sp.userToken},
      body: body,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }

  Future<bool> updateFirm({
    required String firmId,
    required Map<String, dynamic> body,
  }) async {
    var response = await apiClient.requestPut(
      '${AppConst.firmsUpdate}/$firmId',
      headers: {'authorization': sp.userToken},
      body: body,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }

  Future<bool> deleteFirm({required String firmId}) async {
    var response = await apiClient.request(
      '${AppConst.firmsDelete}/$firmId',
      headers: {'authorization': sp.userToken},
      method: ApiType.delete,
    );

    var data = jsonDecode(response);

    return data['code'] == 'OK';
  }
}
