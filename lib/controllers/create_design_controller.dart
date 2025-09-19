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

  String selectedDesignModelId = '';
  RxString selectedDesignImage = ''.obs;

  RxString err = ''.obs;

  RxBool isLoading = false.obs;

  int currentPage = 1;
  int totalPages = 0;
  int limit = 10000;
  RxBool hasMore = false.obs;
  String imageBasePath = '';
  RxList<DesignModel> designList = RxList();

  setDefaultFields(DesignModel design) {
    designNameCont.text = design.designName;
    designNumberCont.text = design.designNumber;
    selectedDesignModelId = design.id;

    if (design.designImage.isNotEmpty) {
      selectedDesignImage.value = design.designImage;
    }
  }

  getTotalPage(int total, int limit) {
    totalPages = (total / limit).ceil();
    if (totalPages > 1) {
      hasMore.value = true;
    }
  }

  nextPage() {
    if (currentPage == totalPages) {
      showSuccessSnackbar('No More Design');
      hasMore.value = false;
    } else {
      hasMore.value = true;
      currentPage++;
      getDesignList();
    }
  }

  @override
  void dispose() {
    super.dispose();
    designNameCont.dispose();
    designNumberCont.dispose();
  }

  void setImage(XFile? img) {
    selectedImage.value = img;
    if (selectedDesignImage.isNotEmpty) {
      selectedDesignImage.value = '';
    }
  }

  getDesignList({String? search, bool isRefresh = false}) async {
    try {
      isLoading.value = true;
      DesignListModel designListModel;
      if (isRefresh) {
        designList.value = [];
        currentPage = 1;
      }
      if (search != null && search.isNotEmpty) {
        designList.value = [];

        designListModel = await createDesignRepo.getDesignList(
          searchText: search,
        );
      } else {
        designListModel = await createDesignRepo.getDesignList(
          searchText: search,
          pageCount: '$currentPage',
          limit: '$limit',
        );
      }

      imageBasePath = designListModel.imgBaseUrl;
      AppConst.imageBaseUrl = designListModel.imgBaseUrl;
      designList.addAll(designListModel.list);
      getTotalPage(designListModel.totalCount, limit);
    } on ApiException catch (e) {
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
    selectedDesignImage.value = '';
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

  deleteDesign() async {
    try {
      isLoading.value = true;
      await createDesignRepo.deleteDesign(id: selectedDesignModelId);
      resetInputs();
      showSuccessSnackbar(
        'Design Delete.',
        decs: 'Design Deleted Successfully.',
      );
      getDesignList(isRefresh: true);
    } on ApiException catch (e) {
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

  updateDesign() async {
    try {
      isLoading.value = true;
      await createDesignRepo.updateDesign(
        id: selectedDesignModelId,
        designName: designNameCont.text.trim(),
        designNumber: designNumberCont.text.trim(),
        isImageRemoved:
            selectedDesignImage.isEmpty && selectedImage.value == null,
        image: selectedImage.value != null
            ? File(selectedImage.value!.path)
            : null,
      );
      resetInputs();

      Get.back();
      showSuccessSnackbar('New Design Create.');
      getDesignList(isRefresh: true);
    } on ApiException catch (e) {
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
