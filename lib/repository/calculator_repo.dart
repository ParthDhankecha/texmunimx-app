import 'dart:developer';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  Future<Uint8List> getImageBytes(String imageUrl) async {
    try {
      //   if (imageUrl != null && imageUrl.isNotEmpty) {
      //   try {
      //     final response = await http.get(Uri.parse(imageUrl));
      //     if (response.statusCode == 200) {
      //       designImageBytes = response.bodyBytes;
      //     } else {
      //       print('Failed to load image from $imageUrl: ${response.statusCode}');
      //     }
      //   } catch (e) {
      //     print('Error loading image: $e');
      //   }
      // }

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        throw Exception('Failed to load image from $imageUrl');
      }
    } catch (e) {
      throw Exception('Error fetching image: $e');
    }
  }
}
