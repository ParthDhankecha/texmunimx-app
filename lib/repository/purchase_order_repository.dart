import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/models/purchase_order_options_response.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/repository/base_model.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class PurchaseOrderRepository {
  ApiClient apiClient = Get.find<ApiClient>();
  Sharedprefs sp = Get.find<Sharedprefs>();

  // get purchase status options
  Future<PurchaseOptionsModel> getOptionsList() async {
    var endPoint = AppConst.purchaseOrderGetOptions;

    var data = await apiClient.request(
      endPoint,
      body: {},
      headers: {'authorization': sp.userToken},
    );

    if (kDebugMode) {
      print('token : ${sp.userToken}');
      print('data : $data');
    }
    return purchaseOrderOptionsResponseFromMap(data).data;
  }

  //function to load purchase order list
  Future<PurchaseOrderListModel> getPurchaseOrderList({
    required String status,
    String? searchText,
    String? limit,
    String? pageCount,
  }) async {
    var endPoint = AppConst.purchaseOrderList;
    var body = {
      'status': status,
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

    log('data : $data');
    return purchaseOrderListResponseFromMap(data).data;
  }

  Future<dynamic> createPurchaseOrder({Map<String, dynamic>? reqBody}) async {
    var endPoint = AppConst.purchaseOrderCreate;
    if (kDebugMode) {
      print('reqBody - $reqBody');
    }
    dynamic data = await apiClient.requestPost(
      endPoint,
      body: reqBody,
      headers: {'authorization': sp.userToken},
    );
    return data;
  }

  //change status
  Future<bool> changeStatus({
    required String id,
    required String status,
    required int quantity,
    String? firmId,
    String? userId,
    String? machineNo,
    String? remarks,
  }) async {
    var endPoint = AppConst.purchaseOrderChangeStatus;
    var body = {
      'status': status,
      'quantity': quantity,
      if (firmId != null) 'firmId': firmId,
      if (userId != null) 'userId': userId,
      if (machineNo != null) 'machineNo': machineNo,
      if (remarks != null) 'remarks': remarks,
    };

    if (kDebugMode) {
      print('token : ${sp.userToken}');
      print('body : $body');
    }
    var data = await apiClient.requestPut(
      '$endPoint/$id',
      body: body,
      headers: {'authorization': sp.userToken},
    );

    log('data : $data');
    return baseModelFromMap(data).code == "OK";
  }
}
