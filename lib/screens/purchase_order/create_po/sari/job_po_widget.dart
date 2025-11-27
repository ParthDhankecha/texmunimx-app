import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/job_po_model.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/delete_job_or_matching_dialog.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/job_po_card.dart';
import 'package:texmunimx/screens/purchase_order/create_po/garments/job_po_garment_card.dart';

class JobPoWidget extends StatefulWidget {
  const JobPoWidget({super.key});

  @override
  State<JobPoWidget> createState() => _JobPoWidgetState();
}

class _JobPoWidgetState extends State<JobPoWidget> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.jobPoList.length,
            itemBuilder: (context, index) {
              JobPoModel model = controller.jobPoList[index];

              if (controller.selectedOrderType.value ==
                  controller.orderTypes[0]) {
                return JobPoGarmentCard(
                  model: model,
                  index: index,
                  users: controller.jobUserList,
                  firms: controller.firmList,
                  matchings: controller.sariMatchingList,
                  isLocked: model.isLocked ?? false,

                  onRemove: () {
                    if (model.user == null) {
                      controller.removeJobPo(index);
                      return;
                    }

                    if (model.firm == null) {
                      controller.removeJobPo(index);
                      return;
                    }

                    if (model.quantity == null || model.quantity == 0) {
                      controller.removeJobPo(index);
                      return;
                    }

                    Get.dialog(
                      DeleteJobOrMatchingDialog(
                        isJob: true,
                        onDelete: () {
                          controller.removeJobPo(index);
                        },
                      ),
                    );
                    //
                    // controller.removeJobPo(index);
                  },

                  onQuantityChange: (value) {
                    log('Quantity changed: $value');
                    //  controller.updateJobQuantity(index, value);
                    model.quantity = int.tryParse(value) ?? 0;
                  },

                  onFirmChange: (value) =>
                      controller.updateJobFirm(index, value),
                  matchingChange: (value) =>
                      controller.updateJobMatching(index, value),
                  userChange: (value) => controller.updateJobUser(index, value),
                  onRemarksChange: (value) =>
                      controller.updateJobRemarks(index, value),
                );
              }
              //type sari
              return JobPoCard(
                model: model,
                index: index,
                users: controller.jobUserList,
                firms: controller.firmList,
                matchings: controller.sariMatchingList,
                // colors: controller.jobColorsList,
                isLocked: model.isLocked ?? false,

                onRemove: () {
                  if (model.user == null) {
                    controller.removeJobPo(index);
                    return;
                  }

                  if (model.firm == null) {
                    controller.removeJobPo(index);
                    return;
                  }

                  if (model.quantity == null || model.quantity == 0) {
                    controller.removeJobPo(index);
                    return;
                  }
                  Get.dialog(
                    DeleteJobOrMatchingDialog(
                      isJob: true,
                      onDelete: () {
                        controller.removeJobPo(index);
                      },
                    ),
                  );
                  //controller.removeJobPo(index);
                },

                onQuantityChange: (value) {
                  controller.updateJobQuantity(index, value);
                },

                onFirmChange: (value) => controller.updateJobFirm(index, value),
                matchingChange: (value) =>
                    controller.updateJobMatching(index, value),

                onColorChange: (value) =>
                    controller.updateJobColor(index, value),
                userChange: (value) => controller.updateJobUser(index, value),
                onRemarksChange: (value) =>
                    controller.updateJobRemarks(index, value),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomBtn(
                title: 'Add New',
                onTap: () {
                  controller.addNewJobPo();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
