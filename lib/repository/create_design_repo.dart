import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class CreateDesignRepo {
  final ApiClient apiClient = Get.find();
  Sharedprefs sp = Get.find();

  Future<DesignListModel> getDesignList() async {
    var endPoint = AppConst.listDesign;

    var data = await apiClient.requestPost(
      endPoint,
      body: {},
      headers: {'authorization': sp.userToken},
    );
    print('data: ${jsonDecode(data)['data']}');
    return designListResponseFromMap(data).designListModel;
  }

  createNewDesign({
    required String designName,
    required String designNumber,
    File? image,
  }) async {
    var endPoint = AppConst.createDesign;
    var reqBody = {'designName': designName, 'designNumber': designNumber};
    dynamic data;

    if (image != null) {
      // Call the multipart request only if an image exists
      print('image path = ${image.path}');
      data = await apiClient.requestMultipartPost(
        endPoint,
        filePath: image.path,
        fileKey: 'file',
        body: reqBody,
        headers: {'authorization': sp.userToken},
      );
    } else {
      // Call a standard POST request if no image is provided
      data = await apiClient.requestPost(
        endPoint,
        body: reqBody,
        headers: {'authorization': sp.userToken},
      );
    }
    return data;
  }

  //list designs
}
