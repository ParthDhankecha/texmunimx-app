import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/common_widgets/show_success_snackbar.dart';
import 'package:texmunimx/models/design_list_response.dart';
import 'package:texmunimx/models/get_po_response.dart';
import 'package:texmunimx/models/in_process_model.dart';
import 'package:texmunimx/models/job_po_model.dart';
import 'package:texmunimx/models/order_history_response.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/party_list_response.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/models/sari_matching_model.dart';
import 'package:texmunimx/repository/api_exception.dart';
import 'package:texmunimx/repository/purchase_order_repository.dart';
import 'package:texmunimx/screens/auth_screens/login_screen.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';

class PurchaseOrderController extends GetxController implements GetxService {
  PurchaseOrderController();

  TextEditingController pannaCont = TextEditingController();
  TextEditingController processCont = TextEditingController();
  TextEditingController quantityCont = TextEditingController();
  TextEditingController rateCont = TextEditingController();
  TextEditingController partyPoCont = TextEditingController();
  TextEditingController deliveryDateCont = TextEditingController();
  TextEditingController notesCont = TextEditingController();

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
  RxList<User> userList = RxList();
  RxList<User> jobUserList = RxList();
  RxList<Design> designList = RxList();
  RxList<Party> partyList = RxList();

  int currentPage = 1;
  int totalPages = 0;
  int limit = 10000;
  RxBool hasMore = false.obs;

  RxString err = ''.obs;

  //order history
  RxList<OrderHistory> orderHistoryList = RxList();

  //orer type
  List<String> orderTypes = ['Garment', 'Sari'];
  RxString selectedOrderType = ''.obs;

  RxList<SariMatchingModel> sariMatchingList = RxList();
  RxList<JobPoModel> jobPoList = RxList();

  RxBool isJobPoEnabled = false.obs;

  changeJobPoEnabled(bool value) {
    isJobPoEnabled.value = value;

    if (value) {
      generateJobPoDefaultBoxes();
    } else {
      jobPoList.value = [];
      jobPoList.refresh();
    }
  }

  generateDefaultBoxes() {
    var list = List.generate(
      1,
      (index) =>
          SariMatchingModel(id: index + 1, matching: 'Matching ${index + 1}'),
    );

    sariMatchingList.value = list;
    jobPoList.refresh();
  }

  removeSariMatching(int index) {
    if (sariMatchingList.length > 1) {
      sariMatchingList.removeAt(index);
      jobPoList.refresh();
    } else {
      showSuccessSnackbar('At least one matching is required');
    }
  }

  updateSariColor1(int index, String value) {
    var model = sariMatchingList[index];
    model.color1 = value;
    sariMatchingList[index] = model;
  }

  updateSariColor2(int index, String value) {
    var model = sariMatchingList[index];
    model.color2 = value;
    sariMatchingList[index] = model;
  }

  updateSariColor3(int index, String value) {
    var model = sariMatchingList[index];
    model.color3 = value;
    sariMatchingList[index] = model;
  }

  updateSariColor4(int index, String value) {
    var model = sariMatchingList[index];
    model.color4 = value;
    sariMatchingList[index] = model;
  }

  updateSariRate(int index, String value) {
    var model = sariMatchingList[index];
    model.rate = double.tryParse(value) ?? 0;
    sariMatchingList[index] = model;
  }

  updateSariQuantity(int index, String value) {
    var model = sariMatchingList[index];
    model.quantity = int.tryParse(value) ?? 0;
    sariMatchingList[index] = model;
  }

  addNewSariMatching() {
    var model = SariMatchingModel(
      id: (sariMatchingList.isNotEmpty
          ? (sariMatchingList.last.id ?? 0) + 1
          : 1),
      matching:
          'Matching ${(sariMatchingList.isNotEmpty ? (sariMatchingList.last.id ?? 0) + 1 : 1)}',
    );
    sariMatchingList.add(model);
    jobPoList.refresh();
  }

  addSariMatchingByModel(SariMatchingModel model) {
    sariMatchingList.add(model);
    sariMatchingList.refresh();
    jobPoList.refresh();
  }

  addSariMatchingByList(List<SariMatchingModel> list) {
    sariMatchingList.addAll(list);
    sariMatchingList.refresh();
    jobPoList.refresh();
  }

  //job po methods
  generateJobPoDefaultBoxes() {
    var list = List.generate(
      1,
      (index) => JobPoModel(id: index + 1, jobPo: 'Job PO ${index + 1}'),
    );

    jobPoList.value = list;
  }

  addNewJobPo() {
    var model = JobPoModel(
      id: (jobPoList.isNotEmpty ? (jobPoList.last.id ?? 0) + 1 : 1),
      jobPo:
          'Job PO ${(jobPoList.isNotEmpty ? (jobPoList.last.id ?? 0) + 1 : 1)}',
    );
    jobPoList.add(model);
  }

  removeJobPo(int index) {
    if (jobPoList.length > 1) {
      jobPoList.removeAt(index);
    } else {
      showSuccessSnackbar('At least one Job PO is required');
    }
  }

  updateJobUser(int index, String value) {
    var model = jobPoList[index];
    model.user = value;
    jobPoList[index] = model;
  }

  updateJobFirm(int index, String value) {
    var model = jobPoList[index];
    model.firm = value;
    jobPoList[index] = model;
  }

  updateJobMatching(int index, String value) {
    var model = jobPoList[index];
    model.matching = value;
    model.mId = sariMatchingList
        .firstWhere(
          (element) => element.matching == value,
          orElse: () => SariMatchingModel(),
        )
        .id
        .toString();
    jobPoList[index] = model;
  }

  updateJobQuantity(int index, String value) {
    var model = jobPoList[index];
    model.quantity = int.tryParse(value) ?? 0;
    jobPoList[index] = model;
  }

  updateJobRemarks(int index, String value) {
    var model = jobPoList[index];
    model.remarks = value;
    jobPoList[index] = model;
  }

  validateGarmetquantity() {
    var mainQuantity = int.tryParse(quantityCont.text.trim()) ?? 0;
    var totalJobQuantity = 0;
    for (var element in jobPoList) {
      totalJobQuantity += element.quantity ?? 0;
    }
    if (totalJobQuantity > mainQuantity) {
      showErrorSnackbar('Job PO quantity should not exceed $mainQuantity');
      return false;
    } else {
      return true;
    }
  }

  //validate machine wise quantity
  validateSariQuantity() {
    bool isValid = true;
    for (var element in jobPoList) {
      var totalJobQuantity = 0;
      var mainQuantity = 0;
      var sari = sariMatchingList.firstWhere(
        (e) => e.matching == element.matching,
        orElse: () => SariMatchingModel(),
      );
      if (sari.quantity != null) {
        mainQuantity = sari.quantity!;
      }

      if (element.matching == sari.matching) {
        totalJobQuantity += element.quantity ?? 0;
      }

      if (totalJobQuantity > mainQuantity) {
        showErrorSnackbar(
          'Job PO quantity should not exceed $mainQuantity for ${sari.matching}',
        );
        isValid = false;
      }
    }
    return isValid;
  }

  changePriority(bool value) {
    highPriority.value = value;
  }

  selectDesign(DesignModel? model) {
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

  fetchOptionsData() async {
    try {
      isLoading.value = true;
      var data = await repository.getOptionsList();
      firmList.value = data.firms;
      userList.value = data.users;
      jobUserList.value = data.jobUsers;

      //fetch design and party list

      designList.value = data.designs;

      partyList.value = data.parties;
    } on ApiException catch (e) {
      log('error : $e');
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

  fatchOrderHistoryById(String id) async {
    try {
      isLoading.value = true;
      var data = await repository.getOrderHistory(id: id);
      orderHistoryList.value = data.orderHistory;
      orderHistoryList.refresh();
    } on ApiException catch (e) {
      log('error : $e');
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

  String firmNameById(String id) {
    try {
      return firmList.firstWhere((element) => element.id == id).firmName;
    } catch (e) {
      return 'N/A';
    }
  }

  String userNameById(String id) {
    try {
      return userList.firstWhere((element) => element.id == id).fullname;
    } catch (e) {
      return 'N/A';
    }
  }

  String getMovedUserById(String id) {
    try {
      return userList.firstWhere((element) => element.id == id).fullname;
    } catch (e) {
      return 'N/A';
    }
  }

  fetchInitialData() async {
    try {
      isLoading.value = true;
      if (firmList.isNotEmpty || userList.isEmpty || jobUserList.isEmpty) {
        firmList.value = [];
        userList.value = [];
        jobUserList.value = [];
        isJobPoEnabled.value = false;
        jobPoList.value = [];
        jobPoList.refresh();
      }

      fetchOptionsData();

      selectDesign(null);
      //generateDefaultBoxes();
      //generateJobPoDefaultBoxes();
      selectedOrderType.value = '';
      err.value = '';
    } on ApiException catch (e) {
      log('error : $e');
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

  fetchDataWithId(String id) async {
    log('fetchDataWithId id: $id');
    try {
      isLoading.value = true;
      var data = await repository.getPurchaseOrderByID(id: id);
      await setEditData(data);
    } on ApiException catch (e) {
      log('error : $e');
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

  setEditData(POModel po) async {
    Design model = designList.firstWhere(
      (element) => element.id == po.designId,
      orElse: () =>
          Design(id: '', designNumber: 'N/A', designName: '', designImage: ''),
    );
    selectedDesign.value = DesignModel(
      id: model.id,
      designName: model.designName,
      designNumber: model.designNumber,
      designImage: model.designImage,
    );

    Party partyModel = partyList.firstWhere(
      (element) => element.id == po.partyId,
      orElse: () =>
          Party(id: '', partyName: 'N/A', partyNumber: '', mobile: ''),
    );
    selectedParty.value = PartyModel(
      id: partyModel.id,
      partyName: partyModel.partyName,
      partyNumber: partyModel.partyNumber,
      mobile: partyModel.mobile,
      email: '',
      gstNo: '',
      address: '',
      contactDetails: '',
      brokerName: '',
    );

    pannaCont.text = po.panna.toString();
    processCont.text = po.process;
    partyPoCont.text = po.partyPoNumber;

    selectedOrderType.value = po.orderType.isNotEmpty
        ? po.orderType.capitalizeFirst!
        : '';

    log('selected order type: ${selectedOrderType.value}');

    if (selectedOrderType.value == orderTypes[0]) {
      //garmets
      quantityCont.text = po.matchings.isNotEmpty
          ? po.matchings
                .map((e) => e.quantity)
                .reduce((a, b) => a + b)
                .toString()
          : '';

      rateCont.text = po.matchings.isNotEmpty
          ? po.matchings.map((e) => e.rate).reduce((a, b) => a + b).toString()
          : '';
    } else if (selectedOrderType.value == orderTypes[1]) {
      //sari

      quantityCont.text = '';
      rateCont.text = '';

      if (sariMatchingList.isNotEmpty) {
        sariMatchingList.value = [];
      }

      for (var element in po.matchings) {
        SariMatchingModel model = SariMatchingModel(
          id: (po.matchings.indexOf(element) + 1),
          matching: element.mLabel,
          rate: element.rate,
          quantity: element.quantity,
          color1: element.colors.isNotEmpty ? element.colors[0] : '',
          color2: element.colors.length > 1 ? element.colors[1] : '',
          color3: element.colors.length > 2 ? element.colors[2] : '',
          color4: element.colors.length > 3 ? element.colors[3] : '',
          isLocked: element.isLocked,
        );

        addSariMatchingByModel(model);
      }
    }

    highPriority.value = po.isHighPriority;
    notesCont.text = po.note;
    if (po.deliveryDate != null && po.deliveryDate!.isNotEmpty) {
      selectedDate.value = DateTime.parse(po.deliveryDate!);
      deliveryDateCont.text = selectedDate.value!.toLocal().ddmmyyFormat;
    } else {
      selectedDate.value = null;
      deliveryDateCont.text = '';
    }

    //jop po
    isJobPoEnabled.value = po.isJobPo;
    if (po.isJobPo) {
      if (selectedOrderType.value == orderTypes[0]) {
        //germent
        jobPoList.value = po.jobUser
            .map(
              (e) => JobPoModel(
                id: (po.jobUser.indexOf(e) + 1),
                jobPo: 'Job PO ${po.jobUser.indexOf(e) + 1}',
                user: e.userId,
                firm: e.firmId,
                quantity: e.quantity,
                mId: '',
                matching: '',
                remarks: '',
                jobId: e.id,
                isLocked: e.isLocked,
              ),
            )
            .toList();
      } else if (selectedOrderType.value == orderTypes[1]) {
        jobPoList.value = po.jobUser
            .map(
              (e) => JobPoModel(
                id: po.jobUser.indexOf(e) + 1,
                jobPo: 'Job PO ${po.jobUser.indexOf(e) + 1}',
                user: e.userId,
                firm: e.firmId,
                quantity: e.quantity,
                mId: e.matchingNo.toString(),
                matching: po.matchings
                    .firstWhere(
                      (element) => element.mid == e.matchingNo,
                      orElse: () => Matching2(
                        colors: [],
                        rate: 0,
                        quantity: 0,
                        pending: 0,
                        mid: 0,
                        mLabel: '',
                        id: '',
                      ),
                    )
                    .mLabel,

                remarks: e.remarks,
                jobId: e.id,
                isLocked: e.isLocked,
              ),
            )
            .toList();
      }
      jobPoList.refresh();
    } else {
      jobPoList.value = [];
    }
    sariMatchingList.refresh();
    jobPoList.refresh();
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
    sariMatchingList.value = [];
    jobPoList.value = [];
    isJobPoEnabled.value = false;
    notesCont.text = '';
    selectedOrderType.value = '';
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
    required bool isJobPo,
    String? machinObjId,
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
        isJobPo: isJobPo,
        machinObjId: machinObjId,
      );
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
      log('error : $e');
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

  updateStatusWithJobPo({
    required String id,
    required OrderStatus status,
    required OrderStatus current,
    required Map<String, dynamic> body,
  }) async {
    try {
      isLoading.value = true;
      var data = await repository.changeOrderStatus(id: id, body: body);
      log('update status data: $data');
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
      log('error : $e');
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
      await fetchOptionsData();
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
      log('error : $e');
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
      log('$status error : $e');
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
      Map<String, dynamic> body = {};

      // if (selectedOrderType.value == orderTypes[0]) {
      //garment
      if (selectedDesign.value == null) {
        showErrorSnackbar('Please select design');
        return;
      }
      if (selectedParty.value == null) {
        showErrorSnackbar('Please select party');
        return;
      }

      if ((quantityCont.text.trim().isEmpty ||
              int.tryParse(quantityCont.text.trim()) == null ||
              (int.tryParse(quantityCont.text.trim()) ?? 0) <= 0) &&
          selectedOrderType.value == orderTypes[0]) {
        showErrorSnackbar('Please enter valid quantity');
        return;
      }

      if ((rateCont.text.trim().isEmpty ||
              double.tryParse(rateCont.text.trim()) == null ||
              (double.tryParse(rateCont.text.trim()) ?? 0) <= 0) &&
          selectedOrderType.value == orderTypes[0] &&
          selectedOrderType.value == orderTypes[0]) {
        showErrorSnackbar('Please enter valid rate');
        return;
      }

      if (isJobPoEnabled.value && selectedOrderType.value == orderTypes[0]) {
        // germent
        if (!validateGarmetquantity()) {
          return;
        }
      } else if (isJobPoEnabled.value &&
          selectedOrderType.value == orderTypes[1]) {
        if (!validateSariQuantity()) {
          return;
        }
      }

      body = {
        if (selectedOrderType.value == orderTypes[0])
          "quantity": int.tryParse(quantityCont.text.trim()) ?? 0,

        if (selectedOrderType.value == orderTypes[0])
          "rate": double.tryParse(rateCont.text.trim()) ?? 0,

        if (pannaCont.text.trim().isNotEmpty)
          "panna": double.tryParse(pannaCont.text.trim()) ?? 0,

        if (partyPoCont.text.trim().isNotEmpty)
          "partyPoNumber": partyPoCont.text.trim(),

        "process": processCont.text.trim().isNotEmpty
            ? processCont.text.trim()
            : 'N/A',

        "designId": selectedDesign.value!.id,
        "partyId": selectedParty.value!.id,

        if (selectedDate.value != null)
          "deliveryDate": selectedDate.value.toString(),

        "isHighPriority": highPriority.value,
        if (notesCont.text.trim().isNotEmpty) "note": notesCont.text.trim(),

        "orderType": selectedOrderType.value.toLowerCase(),

        if (isJobPoEnabled.value) "isJobPo": true,

        if (selectedOrderType.value == orderTypes[1])
          //for sari section
          "matchings": sariMatchingList.map((e) {
            return {
              "mid": e.id,
              "mLabel": e.matching,
              "rate": e.rate,
              "quantity": e.quantity ?? 0,
              "colors": [
                e.color1 ?? '',
                e.color2 ?? '',
                e.color3 ?? '',
                e.color4 ?? '',
              ],
            };
          }).toList(),

        if (isJobPoEnabled.value)
          "jobUser": jobPoList.map((e) {
            if (e.user == null || e.user!.isEmpty) {
              throw 'Please select user for all Job PO';
            }
            if (e.firm == null || e.firm!.isEmpty) {
              throw 'Please select firm for all Job PO';
            }
            if (e.quantity == null || e.quantity == 0) {
              throw 'Please enter quantity for all Job PO';
            }

            return {
              "quantity": e.quantity,
              "remarks": e.remarks,
              "userId": e.user,
              "firmId": e.firm,
              if (selectedOrderType.value == orderTypes[1]) "matchingNo": e.mId,
            };
          }).toList(),
      };
      // } else if (selectedOrderType.value == orderTypes[1]) {
      //sari
      //  }

      // body = {
      //   "quantity": 100,
      //   "rate": 5,
      //   "panna": 42,
      //   "partyPoNumber": "12341",
      //   "process": "print",
      //   "designId": "68e88d0bbb41a102c1d09725",
      //   "partyId": "68e88cc5bb41a102c1d096f9",
      //   "deliveryDate": "2025-10-17",
      //   "isHighPriority": false,
      //   "note": "notes",
      //   "orderType": "garment",
      //   "isJobPo": false,
      // };
      await repository.createPurchaseOrder(reqBody: body);

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
    } catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
      if (e is String) {
        showErrorSnackbar(e);
      } else {
        showErrorSnackbar('Something went wrong, please try again later.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  //update purchase order
  updatePurchaseOrder(String id) async {
    try {
      isLoading.value = true;
      Map<String, dynamic> body = {};

      // if (selectedOrderType.value == orderTypes[0]) {
      //garment
      if (selectedDesign.value == null) {
        showErrorSnackbar('Please select design');
        return;
      }
      if (selectedParty.value == null) {
        showErrorSnackbar('Please select party');
        return;
      }

      if ((quantityCont.text.trim().isEmpty ||
              int.tryParse(quantityCont.text.trim()) == null ||
              (int.tryParse(quantityCont.text.trim()) ?? 0) <= 0) &&
          selectedOrderType.value == orderTypes[0]) {
        showErrorSnackbar('Please enter valid quantity');
        return;
      }

      if ((rateCont.text.trim().isEmpty ||
              double.tryParse(rateCont.text.trim()) == null ||
              (double.tryParse(rateCont.text.trim()) ?? 0) <= 0) &&
          selectedOrderType.value == orderTypes[0] &&
          selectedOrderType.value == orderTypes[0]) {
        showErrorSnackbar('Please enter valid rate');
        return;
      }

      if (isJobPoEnabled.value && selectedOrderType.value == orderTypes[0]) {
        // germent
        if (!validateGarmetquantity()) {
          return;
        }
      } else if (isJobPoEnabled.value &&
          selectedOrderType.value == orderTypes[1]) {
        if (!validateSariQuantity()) {
          return;
        }
      }

      body = {
        'id': id,
        if (selectedOrderType.value == orderTypes[0])
          "quantity": int.tryParse(quantityCont.text.trim()) ?? 0,

        if (selectedOrderType.value == orderTypes[0])
          "rate": double.tryParse(rateCont.text.trim()) ?? 0,

        if (pannaCont.text.trim().isNotEmpty)
          "panna": double.tryParse(pannaCont.text.trim()) ?? 0,

        if (partyPoCont.text.trim().isNotEmpty)
          "partyPoNumber": partyPoCont.text.trim(),

        "process": processCont.text.trim().isNotEmpty
            ? processCont.text.trim()
            : 'N/A',

        "designId": selectedDesign.value!.id,
        "partyId": selectedParty.value!.id,

        if (selectedDate.value != null)
          "deliveryDate": selectedDate.value.toString(),

        "isHighPriority": highPriority.value,
        if (notesCont.text.trim().isNotEmpty) "note": notesCont.text.trim(),

        "orderType": selectedOrderType.value.toLowerCase(),

        if (isJobPoEnabled.value) "isJobPo": true,

        if (selectedOrderType.value == orderTypes[1])
          //for sari section
          "matchings": sariMatchingList.map((e) {
            return {
              "mid": e.id,
              "mLabel": e.matching,
              "rate": e.rate,
              "quantity": e.quantity ?? 0,
              "colors": [
                e.color1 ?? '',
                e.color2 ?? '',
                e.color3 ?? '',
                e.color4 ?? '',
              ],
            };
          }).toList(),

        if (isJobPoEnabled.value)
          "jobUser": jobPoList.map((e) {
            if (e.user == null || e.user!.isEmpty) {
              throw 'Please select user for all Job PO';
            }
            if (e.firm == null || e.firm!.isEmpty) {
              throw 'Please select firm for all Job PO';
            }
            if (e.quantity == null || e.quantity == 0) {
              throw 'Please enter quantity for all Job PO';
            }

            return {
              "quantity": e.quantity,
              "remarks": e.remarks,
              "userId": e.user,
              "firmId": e.firm,
              if (selectedOrderType.value == orderTypes[1]) "matchingNo": e.mId,
            };
          }).toList(),
      };

      await repository.updatePurchaseOrder(reqBody: body);
      Get.back();

      showSuccessSnackbar(
        'Order Updated Successfully.',
        decs: 'Order Updated Successfully.',
      );
      resetInputs();
      getPurchaseList(isRefresh: true);
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
    } catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
      if (e is String) {
        showErrorSnackbar(e);
      } else {
        showErrorSnackbar('Something went wrong, please try again later.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // delete purchase order
  deletePurchaseOrder(String id) async {
    try {
      isLoading.value = true;

      await repository.deletePurchaseOrder(id);
      Get.back();

      showSuccessSnackbar('Order Deleted Successfully.');
      resetInputs();

      getPurchaseList(isRefresh: true);
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
    } catch (e) {
      if (kDebugMode) {
        print('error : $e');
      }
      showErrorSnackbar('Something went wrong, please try again later.');
    } finally {
      isLoading.value = false;
    }
  }
}
