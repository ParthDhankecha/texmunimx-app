import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_po/common_widgets/show_success_snackbar.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/create_design_repo.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/shared_pref.dart';

class CreateDesignController extends GetxController implements GetxService {
  CreateDesignRepo createDesignRepo = Get.find<CreateDesignRepo>();
  Sharedprefs sp = Get.find<Sharedprefs>();

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

  TextEditingController designNameCont = TextEditingController();
  TextEditingController designNumberCont = TextEditingController();

  RxString err = ''.obs;

  RxBool isLoading = false.obs;

  RxInt currentPage = 1.obs;
  RxInt limit = 1000.obs;
  String imageBasePath = '';

  RxList<DesignModel> designList = RxList();

  @override
  void dispose() {
    super.dispose();
    designNameCont.dispose();
    designNumberCont.dispose();
  }

  void setImage(XFile? img) {
    selectedImage.value = img;
  }

  getDesignList() async {
    try {
      isLoading.value = true;
      DesignListModel designListModel = await createDesignRepo.getDesignList();
      currentPage.value = designListModel.totalCount;
      imageBasePath = designListModel.imgBaseUrl;
      AppConst.imageBaseUrl = designListModel.imgBaseUrl;
      designList.value = designListModel.list;
    } on ApiException catch (e) {
      print('error : $e');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }

  onCreatePo() {
    err.value = '';
    String designName = designNameCont.text.trim();
    String designNumber = designNumberCont.text.trim();

    if (designName.isEmpty) {
      err.value = 'Design Name is Mandatory';
      return;
    } else if (designNumber.isEmpty) {
      err.value = 'Design Number is Mandatory';
      return;
    } else {
      createNewDesign();
    }
  }

  void resetInputs() {
    designNameCont.text = '';
    designNumberCont.text = '';
    selectedImage.value = null;
  }

  //function to save design
  createNewDesign() async {
    try {
      isLoading.value = true;
      await createDesignRepo.createNewDesign(
        designName: designNameCont.text.trim(),
        designNumber: designNumberCont.text.trim(),
        image: selectedImage.value != null
            ? File(selectedImage.value!.path)
            : null,
      );
      resetInputs();
      showSuccessSnackbar('New Design Create.');
    } on ApiException catch (e) {
      print('error : $e');
      switch (e.statusCode) {
        case 401:
          Get.offAll(() => LoginScreen());
          break;
        default:
      }
    } finally {
      isLoading.value = false;
    }
  }
}
