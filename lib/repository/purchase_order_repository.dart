import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:texmunimx/models/get_po_response.dart';
import 'package:texmunimx/models/order_history_response.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/repository/base_model.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/shared_pref.dart';

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

  //get purchase order by id
  Future<POModel> getPurchaseOrderByID({required String id}) async {
    var endPoint = AppConst.purchaseOrder;

    if (kDebugMode) {
      print('token : ${sp.userToken}');
    }
    var data = await apiClient.request(
      '$endPoint/$id',

      headers: {'authorization': sp.userToken},
    );

    log('data : $data');
    return getPoResponseFromMap(data).data;
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

  Future<dynamic> updatePurchaseOrder({Map<String, dynamic>? reqBody}) async {
    var endPoint = '${AppConst.purchaseOrderUpdate}/${reqBody?['id']}';
    if (kDebugMode) {
      print('reqBody - $reqBody');
    }
    dynamic data = await apiClient.requestPut(
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
    required bool isJobPo,
    String? machinObjId,
  }) async {
    var endPoint = AppConst.purchaseOrderChangeStatus;
    var body = {
      'status': status,
      'quantity': quantity,
      if (machineNo != null) 'machineNo': machineNo,
      if (remarks != null) 'remarks': remarks,
    };

    if (isJobPo) {
      if (machinObjId != null) body['machineObjId'] = machinObjId;
      if (firmId != null) body['firmId'] = firmId;
      if (userId != null) body['jobUserId'] = userId;
    } else {
      if (userId != null) body['jobUserId'] = userId;
    }

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

  Future<bool> changeOrderStatus({
    Map<String, dynamic>? body,
    required String id,
  }) async {
    var endPoint = AppConst.purchaseOrderChangeStatus;

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

  //get order history
  Future<OrderHistoryListModel> getOrderHistory({String? id}) async {
    var endPoint = AppConst.orderHistory;

    var data = await apiClient.request(
      '$endPoint/$id',
      body: {},
      headers: {'authorization': sp.userToken},
    );

    if (kDebugMode) {
      print('token : ${sp.userToken}');
      print('data : $data');
    }
    return orderHistoryResponseFromMap(data).data;
  }
}
