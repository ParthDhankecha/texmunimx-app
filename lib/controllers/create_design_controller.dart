import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/design_list_response.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/create_design_repo.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/utils/shared_pref.dart';

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

  RxString searchQuery = ''.obs;

  setDefaultFields(DesignModel design) {
    designNameCont.text = design.designName;
    designNumberCont.text = design.designNumber;
    selectedDesignModelId = design.id;

    if (design.designImage.isNotEmpty) {
      selectedDesignImage.value = design.designImage;
    } else {
      selectedDesignImage.value = '';
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
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    debounce<String>(
      searchQuery,
      (_) => getDesignList(search: searchQuery.value),
      time: const Duration(milliseconds: 500),
    );
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
      if ((search != null && search.isEmpty) || search == null) {
        designList.value = [];
        currentPage = 1;

        designListModel = await createDesignRepo.getDesignList(
          pageCount: '$currentPage',
          limit: '$limit',
        );
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
      showSuccessSnackbar('design_updated_successfully'.tr);

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
