import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/party_list_response.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/party_repo.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class PartyController extends GetxController implements GetxService {
  PartyRepo partyRepo = Get.find<PartyRepo>();
  Sharedprefs sp = Get.find<Sharedprefs>();

  TextEditingController partyNameCont = TextEditingController();
  TextEditingController partyNumberCont = TextEditingController();
  TextEditingController gstCont = TextEditingController();
  TextEditingController phoneNumberCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController brokerCont = TextEditingController();

  String selectPartyId = '';

  RxString err = ''.obs;

  RxBool isLoading = false.obs;

  int currentPage = 1;
  int totalPages = 0;
  int limit = 10000;
  RxBool hasMore = false.obs;
  String imageBasePath = '';

  RxList<PartyModel> partyList = RxList();

  RxString searchQuery = ''.obs;

  bool checkValidation() {
    err.value = '';
    if (partyNameCont.text.trim().isEmpty) {
      err.value = 'please_enter_party_name'.tr;
      return false;
    }
    // if (partyNumberCont.text.trim().isEmpty) {
    //   err.value = 'please_enter_party_number'.tr;
    //   return false;
    // }

    // if (gstCont.text.trim().isEmpty) {
    //   err.value = 'please_enter_gst_number'.tr;
    //   return false;
    // }

    return true;
  }

  setDefaultFields(PartyModel? model) {
    if (model != null) {
      selectPartyId = model.id;
      partyNameCont.text = model.partyName;
      partyNumberCont.text = model.partyNumber;
      gstCont.text = model.gstNo ?? '';
      phoneNumberCont.text = model.mobile ?? '';
      emailCont.text = model.email ?? '';
      addressCont.text = model.address ?? '';
      brokerCont.text = model.brokerName ?? '';
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
      getPartyList();
    }
  }

  disposeControllers() {
    partyNameCont.dispose();
    partyNumberCont.dispose();
    gstCont.dispose();
    phoneNumberCont.dispose();
    emailCont.dispose();
    addressCont.dispose();
    brokerCont.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    debounce<String>(
      searchQuery,
      (_) => getPartyList(search: searchQuery.value),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    disposeControllers();
  }

  getPartyList({String? search, bool isRefresh = false}) async {
    try {
      isLoading.value = true;
      PartyListModel partyListModel;
      if (isRefresh) {
        partyList.value = [];
        currentPage = 1;
      }

      if ((search != null && search.isEmpty) || search == null) {
        partyList.value = [];
        currentPage = 1;

        partyListModel = await partyRepo.getPartyList(
          pageCount: '$currentPage',
          limit: '$limit',
        );
      }

      if (search != null && search.isNotEmpty) {
        partyList.value = [];
        partyListModel = await partyRepo.getPartyList(searchText: search);
      } else {
        partyListModel = await partyRepo.getPartyList(
          searchText: search,
          pageCount: '$currentPage',
          limit: '$limit',
        );
      }

      partyList.addAll(partyListModel.list);
      getTotalPage(partyListModel.totalCount, limit);
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

  void resetInputs() {
    partyNameCont.text = '';
    partyNumberCont.text = '';
    gstCont.text = '';
    phoneNumberCont.text = '';
    emailCont.text = '';
    addressCont.text = '';
    brokerCont.text = '';
  }

  createNewParty() async {
    try {
      isLoading.value = true;
      await partyRepo.createNewPart(
        partyName: partyNameCont.text.trim(),
        partyNumber: partyNumberCont.text.trim(),
        gstNo: gstCont.text.trim(),
        mobile: phoneNumberCont.text.trim(),
        email: emailCont.text.trim(),
        address: addressCont.text.trim(),
        brokerName: brokerCont.text.trim(),
      );
      Get.back();

      showSuccessSnackbar('New Party Created.');
      resetInputs();
      getPartyList(isRefresh: true);
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
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

  updateParty() async {
    try {
      isLoading.value = true;
      await partyRepo.updateParty(
        id: selectPartyId,
        partyName: partyNameCont.text.trim(),
        partyNumber: partyNumberCont.text.trim(),
        gstNo: gstCont.text.trim(),
        mobile: phoneNumberCont.text.trim(),
        email: emailCont.text.trim(),
        address: addressCont.text.trim(),
        brokerName: brokerCont.text.trim(),
      );
      Get.back();

      showSuccessSnackbar(' Party with name ${partyNameCont.text} is Updated.');
      resetInputs();
      getPartyList(isRefresh: true);
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
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

  deleteParty() async {
    try {
      isLoading.value = true;
      await partyRepo.deleteParty(id: selectPartyId);
      Get.back();

      showSuccessSnackbar('Party Deleted successfully.');
      resetInputs();
      getPartyList(isRefresh: true);
    } on ApiException catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
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
