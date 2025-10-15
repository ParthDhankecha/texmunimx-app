import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:texmunimx/models/party_list_response.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class PartyRepo {
  final ApiClient apiClient = Get.find();
  Sharedprefs sp = Get.find();

  Future<PartyListModel> getPartyList({
    String? searchText,
    String? limit,
    String? pageCount,
  }) async {
    var endPoint = AppConst.listParty;
    var body = {
      if (searchText != null) 'search': searchText,
      if (limit != null) 'limit': limit,
      if (pageCount != null) 'page': pageCount,
    };

    if (kDebugMode) {
      print('token : ${sp.userToken}');
    }
    var data = await apiClient.requestPost(
      endPoint,
      body: body,
      headers: {'authorization': sp.userToken},
    );
    return partyListResponseFromMap(data).data;
  }

  createNewPart({
    required String partyName,
    required String partyNumber,
    String gstNo = '',
    String mobile = '',
    String email = '',
    String address = '',
    String brokerName = '',

    File? image,
  }) async {
    var endPoint = AppConst.createParty;
    var reqBody = {
      "mobile": mobile,
      "email": email,
      // "_id": id,
      "partyName": partyName,
      "partyNumber": partyNumber,
      "GSTNo": gstNo,
      "address": address,
      "brokerName": brokerName,
    };

    if (kDebugMode) {
      print('reqBody - $reqBody');
    }
    dynamic data;

    data = await apiClient.requestPost(
      endPoint,
      body: reqBody,
      headers: {'authorization': sp.userToken},
    );

    return data;
  }

  updateParty({
    required String id,
    String? partyName,
    String? partyNumber,
    String? gstNo,
    String? mobile,
    String? email,
    String? address,
    String? brokerName,

    File? image,
  }) async {
    var endPoint = '${AppConst.updateParty}/$id';
    var reqBody = {
      if (mobile != null) "mobile": mobile,
      if (email != null) "email": email,
      if (partyName != null) "partyName": partyName,
      if (partyNumber != null) "partyNumber": partyNumber,
      if (gstNo != null) "GSTNo": gstNo,
      if (address != null) "address": address,
      if (brokerName != null) "brokerName": brokerName,
    };

    dynamic data;

    data = await apiClient.requestPut(
      endPoint,
      body: reqBody,
      headers: {'authorization': sp.userToken},
    );

    return data;
  }

  //delete design
  Future<dynamic> deleteParty({required String id}) async {
    var endPoint = '${AppConst.deleteParty}/$id';

    var data = await apiClient.request(
      method: ApiType.delete,
      endPoint,
      body: {},
      headers: {'authorization': sp.userToken},
    );
    //designImage:removed
    return data;
  }
}
