import 'dart:io';

import 'package:get/get.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class CreateDesignRepo {
  final ApiClient apiClient = Get.find();
  Sharedprefs sp = Get.find();

  Future<DesignListModel> getDesignList({
    String? searchText,
    String? limit,
    String? pageCount,
  }) async {
    var endPoint = AppConst.listDesign;
    var body = {
      if (searchText != null) 'search': searchText,
      if (limit != null) 'limit': limit,
      if (pageCount != null) 'page': pageCount,
    };

    var data = await apiClient.requestPost(
      endPoint,
      body: body,
      headers: {'authorization': sp.userToken},
    );
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

  updateDesign({
    required String? designName,
    required String? designNumber,
    required String id,
    required bool isImageRemoved,
    File? image,
  }) async {
    var endPoint = AppConst.updateDesign;
    var reqBody = {
      if (designName != null) 'designName': designName,
      if (designNumber != null) 'designNumber': designNumber,
      if (isImageRemoved) 'designImage': 'remove',
    };
    dynamic data;

    data = await apiClient.requestMultipartPut(
      '$endPoint/$id', // Assuming your API uses a path parameter for ID
      filePath: image?.path,
      fileKey: 'file',
      body: reqBody,
      headers: {'authorization': sp.userToken},
    );

    return data;
  }

  //delete design
  Future<dynamic> deleteDesign({required String id}) async {
    var endPoint = '${AppConst.listDelete}/$id';

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
