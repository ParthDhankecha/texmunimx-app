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

      showSuccessSnackbar(
        'New Party Created.',
        decs: 'New Party with name ${partyNameCont.text} is created.',
      );
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

      showSuccessSnackbar(
        'Party Updated.',
        decs: 'Party with name ${partyNameCont.text} is Updated.',
      );
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

      showSuccessSnackbar(
        'Party Deleted.',
        decs: 'Party Deleted Successfully.',
      );
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
