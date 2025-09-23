import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/show_success_snackbar.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/models/in_process_model.dart';
import 'package:textile_po/models/order_status_enum.dart';
import 'package:textile_po/models/party_list_response.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/repository/api_exception.dart';
import 'package:textile_po/repository/purchase_order_repository.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/utils/date_formate_extension.dart';

class PurchaseOrderController extends GetxController implements GetxService {
  PurchaseOrderController();

  TextEditingController pannaCont = TextEditingController();
  TextEditingController processCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController rateCont = TextEditingController();
  TextEditingController partyPoCont = TextEditingController();
  TextEditingController deliveryDateCont = TextEditingController();

  RxBool highPriority = false.obs;

  RxBool isLoading = false.obs;

  Rx<DateTime?> selectedDate = Rx(null);

  Rx<DesignModel?> selectedDesign = Rx(null);
  Rx<PartyModel?> selectedParty = Rx(null);

  RxList<PurchaseOrderModel> purchaseOrdersList = RxList();
  RxList<PurchaseOrderModel> inProcessList = RxList();
  RxList<PurchaseOrderModel> readyToDispatchList = RxList();
  RxList<PurchaseOrderModel> deliveredList = RxList();

  PurchaseOrderRepository repository = Get.find<PurchaseOrderRepository>();

  RxList<FirmId> firmList = RxList();
  RxList<MovedBy> userList = RxList();

  int currentPage = 1;
  int totalPages = 0;
  int limit = 10000;
  RxBool hasMore = false.obs;

  RxString err = ''.obs;

  changePriority(bool value) {
    highPriority.value = value;
  }

  selectDesign(DesignModel model) {
    selectedDesign.value = model;
  }

  resetSelectedDesign() {
    selectedDesign.value = null;
  }

  selectParty(PartyModel model) {
    selectedParty.value = model;
  }

  resetSelectedParty() {
    selectedParty.value = null;
  }

  resetInputs() {
    pannaCont.clear();
    processCont.clear();
    quantityCont.clear();
    rateCont.clear();
    partyPoCont.clear();
    deliveryDateCont.clear();
    selectedDesign.value = null;
    selectedParty.value = null;
    highPriority.value = false;
    selectedDate.value = null;
  }

  getTotalPage(int total, int limit) {
    totalPages = (total / limit).ceil();
    if (totalPages > 1) {
      hasMore.value = true;
    }
  }

  //update order status
  updateOrderStatus({
    required String id,
    required OrderStatus status,
    required OrderStatus current,
    required int quantity,
    String? fId,
    String? uId,
    String? machineNo,
    String? remarks,
  }) async {
    try {
      isLoading.value = true;
      var data = await repository.changeStatus(
        id: id,
        status: status.name,
        quantity: quantity,
        firmId: fId,
        userId: uId,
        machineNo: machineNo,
        remarks: remarks,
      );
      print('data : $data');
      if (data) {
        showSuccessSnackbar('Status Changed to ${status.displayValue}');

        switch (current) {
          case OrderStatus.pending:
            getPurchaseList(isRefresh: true);

            break;

          default:
            getInProcessList(status: current.name, isRefresh: true);
        }
      }
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

  getPurchaseList({
    String status = 'pending',
    String? search,
    bool isRefresh = false,
  }) async {
    try {
      isLoading.value = true;
      PurchaseOrderListModel purchaseOrderListModel;
      if (isRefresh) {
        purchaseOrdersList.value = [];
        currentPage = 1;
      }
      if (search != null && search.isNotEmpty) {
        purchaseOrdersList.value = [];
        purchaseOrderListModel = await repository.getPurchaseOrderList(
          searchText: search,
          status: status,
        );
      } else {
        purchaseOrderListModel = await repository.getPurchaseOrderList(
          status: 'pending',
          searchText: search,
          pageCount: '$currentPage',
          limit: '$limit',
        );
      }

      var data = await repository.getOptionsList();
      firmList.value = data.firms;
      userList.value = data.users;

      purchaseOrdersList.addAll(purchaseOrderListModel.list);
      getTotalPage(purchaseOrderListModel.totalCount, limit);
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

  //get in process list
  getInProcessList({
    String status = 'inProcess',
    String? search,
    bool isRefresh = false,
  }) async {
    try {
      isLoading.value = true;
      PurchaseOrderListModel purchaseOrderListModel;
      if (isRefresh) {
        inProcessList.value = [];
        readyToDispatchList.value = [];
        deliveredList.value = [];
        currentPage = 1;
      }
      if (search != null && search.isNotEmpty) {
        inProcessList.value = [];

        purchaseOrderListModel = await repository.getPurchaseOrderList(
          searchText: search,
          status: status,
        );
      } else {
        purchaseOrderListModel = await repository.getPurchaseOrderList(
          status: status,
          searchText: search,
          pageCount: '$currentPage',
          limit: '$limit',
        );
      }
      if (status == 'inProcess') {
        inProcessList.addAll(purchaseOrderListModel.list);
      } else if (status == 'delivered') {
        deliveredList.addAll(purchaseOrderListModel.list);
      } else {
        readyToDispatchList.addAll(purchaseOrderListModel.list);
      }
      getTotalPage(purchaseOrderListModel.totalCount, limit);
    } on ApiException catch (e) {
      print('$status error : $e');
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

  createPurchaseOrder() async {
    try {
      isLoading.value = true;
      await repository.createPurchaseOrder(
        panna: double.tryParse(pannaCont.text.trim()) ?? 0,
        process: processCont.text.trim(),
        designId: selectedDesign.value?.id ?? '',
        partyId: selectedParty.value?.id ?? '',
        quantity: int.tryParse(quantityCont.text.trim()) ?? 1,
        rate: double.tryParse(rateCont.text.trim()) ?? 0,
        highPriority: highPriority.value,
        deliveryDate: selectedDate.value?.ddmmyyFormat,
        partyPo: partyPoCont.text.trim(),
      );

      showSuccessSnackbar(
        'New Order Created.',
        decs: 'New Order Created Successfully.',
      );
      resetInputs();
      //  getPartyList(isRefresh: true);
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
