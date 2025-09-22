import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class PurchaseOrderRepository {
  ApiClient apiClient = Get.find<ApiClient>();
  Sharedprefs sp = Get.find<Sharedprefs>();

  //function to load purchase order list
  Future<PurchaseOrderListModel> getPurchaseOrderList({
    String status = 'pending',
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

    print('data : $data');
    return purchaseOrderListResponseFromMap(data).data;
  }

  Future<dynamic> createPurchaseOrder({
    required double panna,
    required String process,
    required String designId,
    required String partyId,
    required int quantity,
    required double rate,
    String? deliveryDate,
    bool? highPriority,
    String? partyPo,
  }) async {
    var endPoint = AppConst.purchaseOrderCreate;
    var reqBody = {
      "panna": '$panna',
      "process": process,
      "designId": designId,
      "partyId": partyId,
      "quantity": '$quantity',
      "rate": '$rate',
      if (deliveryDate != null) "deliveryDate": deliveryDate,
      if (highPriority != null) "isHighPriority": '$highPriority',
      if (partyPo != null) "poNumber": partyPo,
    };

    if (kDebugMode) {
      print('reqBody - $reqBody');
    }

    dynamic data;

    data = await apiClient.requestPost(
      endPoint,
      body: reqBody,
      headers: {
        'authorization': sp.userToken,
        //  'content-type': "application/json",
      },
    );

    return data;
  }
}
