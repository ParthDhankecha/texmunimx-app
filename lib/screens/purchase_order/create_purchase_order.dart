import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/date_input_field.dart';
import 'package:textile_po/common_widgets/error_row.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/screens/purchase_order/widgets/browse_design.dart';
import 'package:textile_po/screens/purchase_order/widgets/browse_party.dart';
import 'package:textile_po/utils/app_colors.dart';

class CreatePurchaseOrder extends StatefulWidget {
  const CreatePurchaseOrder({super.key});

  @override
  State<CreatePurchaseOrder> createState() => _CreatePurchaseOrderState();
}

class _CreatePurchaseOrderState extends State<CreatePurchaseOrder> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.selectDesign(null);
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
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => controller.err.value.isNotEmpty
                    ? ErrorRow(title: controller.err.value)
                    : SizedBox.shrink(),
              ),
              BrowseDesign(controller: controller),
              SizedBox(height: 20),
              BrowseParty(controller: controller),
              SizedBox(height: 20),
              //quality specification
              Row(
                children: [
                  Text('quality_specifications'.tr, style: titleStyle),
                ],
              ),
              Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Column(
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
                      ),
                      SizedBox(height: 10),

                      //process
                      Column(
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
                      ),
                      SizedBox(height: 14),
                      //order details
                      Row(
                        children: [Text('order_details'.tr, style: titleStyle)],
                      ),
                      SizedBox(height: 10),

                      //quantity
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'quantity'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InputField(
                            textEditingController: controller.quantityCont,
                            hintText: 'enter_total_quantity'.tr,
                            textInputType: TextInputType.number,
                            onValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Field is Required';
                              }
                              int i = int.tryParse(value) ?? 0;
                              if (i <= 0) {
                                return 'Quantity Must be grated then 0';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      //rate
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'rate'.tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InputField(
                            textEditingController: controller.rateCont,
                            hintText: 'enter_rate_per_unit'.tr,
                            textInputType: TextInputType.number,
                            onValidator: (value) {
                              if (value!.isEmpty) {
                                return 'Field is Required';
                              }

                              return null;
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      //party po number
                      Column(
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
}
