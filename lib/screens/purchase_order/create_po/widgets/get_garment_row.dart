import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/utils/app_colors.dart';

class GetGarmentRow extends StatelessWidget {
  const GetGarmentRow({super.key, required this.controller});

  final PurchaseOrderController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                SizedBox(width: 6),
                RedMark(),
              ],
            ),
            SizedBox(height: 10),
            //quantity
            InputField(
              textEditingController: controller.quantityCont,
              hintText: 'enter_total_quantity'.tr,
              textInputType: TextInputType.number,
              onValidator: (value) {
                //validation only for garment
                if (controller.selectedOrderType.value ==
                    controller.orderTypes[0]) {
                  if (value!.isEmpty) {
                    return 'Field is Required';
                  }
                  int i = int.tryParse(value) ?? 0;
                  if (i <= 0) {
                    return 'Quantity Must be grated then 0';
                  }
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
                SizedBox(width: 6),
                RedMark(),
              ],
            ),
          ],
        ),

        SizedBox(height: 10),
        InputField(
          textEditingController: controller.rateCont,
          hintText: 'enter_rate_per_unit'.tr,
          textInputType: TextInputType.number,
          onValidator: (value) {
            if (controller.selectedOrderType.value ==
                controller.orderTypes[0]) {
              if (value!.isEmpty) {
                return 'Field is Required';
              }
            }

            return null;
          },
        ),
      ],
    );
  }
}
