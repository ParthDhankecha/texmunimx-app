import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/custom_dropdown.dart';
import 'package:texmunimx/common_widgets/date_input_field.dart';
import 'package:texmunimx/common_widgets/error_row.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/common_widgets/show_error_snackbar.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/get_garment_row.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/job_po_widget.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/sari_widget.dart';
import 'package:texmunimx/screens/purchase_order/widgets/browse_design.dart';
import 'package:texmunimx/screens/purchase_order/widgets/browse_party.dart';
import 'package:texmunimx/utils/app_colors.dart';

class CreatePurchaseOrder extends StatefulWidget {
  const CreatePurchaseOrder({super.key, this.po});

  final PurchaseOrderModel? po;

  @override
  State<CreatePurchaseOrder> createState() => _CreatePurchaseOrderState();
}

class _CreatePurchaseOrderState extends State<CreatePurchaseOrder> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PurchaseOrderModel? get po => widget.po;

  @override
  void initState() {
    super.initState();
    controller.fetchInitialData();
    if (po != null) {
      controller.fetchDataWithId(po!.id);
    } else {
      controller.resetInputs();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.selectDesign(null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('purchase_order'.tr, style: appbarStyle),
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView(
                  primary: true,
                  children: [
                    Obx(
                      () => controller.err.value.isNotEmpty
                          ? ErrorRow(title: controller.err.value)
                          : SizedBox.shrink(),
                    ),
                    BrowseDesign(controller: controller),
                    SizedBox(height: 20),
                    BrowseParty(controller: controller),
                    SizedBox(height: 10),

                    Padding(
                      padding: EdgeInsetsGeometry.all(6),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            _buildPannaRow(),
                            SizedBox(height: 10),

                            //process
                            _buildProcessRow(),
                            SizedBox(height: 14),
                            //party po number
                            _partyPORow(),
                            SizedBox(height: 10),

                            Obx(
                              () => CustomDropdown<String>(
                                title: 'order_type'.tr,
                                items: controller.orderTypes,
                                selectedValue:
                                    controller.selectedOrderType.value == ''
                                    ? null
                                    : controller.selectedOrderType.value,
                                isRequired: true,
                                onChanged: (value) {
                                  log('Dropdown changed: $value');
                                  if (value != null) {
                                    controller.selectedOrderType.value = value;
                                    controller.jobPoList.value = [];

                                    if (value == controller.orderTypes[1]) {
                                      controller.generateDefaultBoxes();
                                    }

                                    log(
                                      'Selected Order Type: ${controller.selectedOrderType.value}',
                                    );
                                  } else {
                                    controller.selectedOrderType.value = '';
                                  }
                                },
                                itemLabelBuilder: (item) => item,
                              ),
                            ),

                            SizedBox(height: 10),
                            //garment section
                            Obx(
                              () =>
                                  controller.selectedOrderType.value
                                          .toLowerCase() ==
                                      controller.orderTypes[0].toLowerCase()
                                  ? GetGarmentRow(controller: controller)
                                  : controller.selectedOrderType.value
                                            .toLowerCase() ==
                                        controller.orderTypes[1].toLowerCase()
                                  ? SariWidget()
                                  : SizedBox.shrink(),
                            ),
                            SizedBox(height: 10),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'delivery_date'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Obx(
                                  () => DateInputField(
                                    selectedDate: controller.selectedDate.value,
                                    onDateSelected: (value) {
                                      controller.selectedDate.value = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'high_priority'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),

                                Obx(
                                  () => Switch(
                                    value: controller.highPriority.value,
                                    onChanged: (value) {
                                      controller.changePriority(value);
                                    },
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'job_po'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),

                                Obx(
                                  () => Switch(
                                    value: controller.isJobPoEnabled.value,
                                    onChanged: (value) {
                                      log(
                                        'job type: ${controller.selectedOrderType.value}',
                                      );
                                      if (controller
                                          .selectedOrderType
                                          .value
                                          .isEmpty) {
                                        controller.err.value =
                                            'Select Order Type';
                                        showErrorSnackbar(controller.err.value);
                                        return;
                                      }
                                      controller.changeJobPoEnabled(value);
                                    },
                                    inactiveTrackColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            Obx(
                              () =>
                                  controller.isJobPoEnabled.value ||
                                      controller.jobPoList.isNotEmpty
                                  ? JobPoWidget()
                                  : SizedBox.shrink(),
                            ),
                            SizedBox(height: 20),
                            CustomBtn(
                              title: 'save_order'.tr,
                              onTap: () {
                                controller.err.value = '';
                                if (controller.selectedDesign.value == null) {
                                  controller.err.value = 'Select Design';
                                }

                                if (controller.selectedParty.value == null) {
                                  controller.err.value = 'Select Party';
                                }

                                if (formKey.currentState!.validate()) {
                                  if (widget.po != null) {
                                    controller.updatePurchaseOrder(
                                      widget.po!.id,
                                    );
                                    return;
                                  }
                                  controller.createPurchaseOrder();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Column _partyPORow() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'party_po_number'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(width: 6),
            RedMark(),
          ],
        ),
        SizedBox(height: 10),
        InputField(
          textEditingController: controller.partyPoCont,
          hintText: 'enter_partys_po_number'.tr,
          textInputType: TextInputType.text,
          onValidator: (value) {
            if (value!.isEmpty) {
              return 'Field is Required';
            }

            return null;
          },
        ),
      ],
    );
  }

  Column _buildProcessRow() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'process'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(width: 6),
            RedMark(),
          ],
        ),
        SizedBox(height: 10),
        InputField(
          textEditingController: controller.processCont,
          hintText: 'dyeing_printing'.tr,
          textInputType: TextInputType.text,
          onValidator: (value) {
            if (value!.isEmpty) {
              return 'Field is Required';
            }

            return null;
          },
        ),
      ],
    );
  }

  Column _buildPannaRow() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'panna'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.blackColor,
              ),
            ),
            SizedBox(width: 6),
            RedMark(),
          ],
        ),
        SizedBox(height: 10),
        InputField(
          textEditingController: controller.pannaCont,
          hintText: 'enter_panna_width'.tr,
          textInputType: TextInputType.number,
          onValidator: (value) {
            if (value!.isEmpty) {
              return 'Field is Required';
            }

            return null;
          },
        ),
      ],
    );
  }
}
