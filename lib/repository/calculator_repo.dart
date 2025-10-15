import 'dart:developer';

import 'package:get/get.dart';
import 'package:texmunimx/models/calculator_get_response.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/repository/base_model.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class CalculatorRepo {
  final ApiClient apiClient = Get.find();
  Sharedprefs sp = Get.find();

  //method to get design details by id
  Future<CalculatorModel> getDesignDetails({String? id}) async {
    var endPoint = id != null
        ? '${AppConst.designDetails}/$id'
        : AppConst.designDetails;
    log('token : ${sp.userToken}');
    var response = await apiClient.request(
      endPoint,
      headers: {'authorization': sp.userToken},
    );

    log('Response from design details: $response');
    var data = calculatorGetResponseFromMap(response);
    if (data.data == null) {
      throw Exception('No data found');
    }
    return data.data!;
  }

  //update data post method
  Future<bool> saveCalculatorData({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    var response = await apiClient.requestPost(
      '${AppConst.calculatorSave}/$id',

      body: body,
      headers: {'authorization': sp.userToken},
    );

    log('Response from save calculator data: $response');
    var data = baseModelFromMap(response);
    if (data.code == "OK") {
      return true;
    } else {
      return false;
    }
  }
}
