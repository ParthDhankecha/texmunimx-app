import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/models/labour_cost_model.dart';
import 'package:texmunimx/screens/calculator/labour/labour_cost_card.dart';
import 'package:texmunimx/utils/app_colors.dart';

class LabourCostList extends StatefulWidget {
  const LabourCostList({super.key});

  @override
  State<LabourCostList> createState() => _LabourCostListState();
}

class _LabourCostListState extends State<LabourCostList> {
  CalculatorController controller = Get.find<CalculatorController>();

  GlobalKey<FormState> labourCostFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Form(
        key: labourCostFormKey,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('design_card'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'design_card'.tr,
                    textEditingController: controller.designCardCont,
                    onTextChange: (value) {
                      // if (labourCostFormKey.currentState!.validate()) {
                      // }
                      controller.setDesignCard = double.tryParse(value) ?? 0.0;
                      controller.addLabourCost();
                    },
                    textInputType: TextInputType.number,
                    onValidator: (value) {
                      // if (value!.isEmpty) {
                      //   return 'design_card_required'.tr;
                      // }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            //add custom cost
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [Text('enter_paisa'.tr, style: bodyStyle)],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'enter_paisa'.tr,
                    onTextChange: (value) {
                      double p = double.tryParse(value) ?? 0.0;
                      controller.setEnterPaisa = p;
                      controller.labourCostByPaisa(p);
                    },
                    textInputType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            titleRow(),
            SizedBox(height: 10),
            Obx(() {
              LabourCostModel model = LabourCostModel(
                paisa: controller.enterPaisa.value,
                cost: controller.costByPaisa.value,
              );
              if (controller.costByPaisa.value == 0 ||
                  controller.enterPaisa.value == 0) {
                return SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: LabourCostCard(item: model, isMain: true),
              );
            }),

            Obx(
              () => controller.labourCostList.isEmpty
                  ? Text('no_data_found'.tr)
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.labourCostList.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = controller.labourCostList[index];
                        return LabourCostCard(item: item);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 8);
                      },
                    ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    child: CustomBtn(
                      title: 'save'.tr,
                      onTap: () {
                        controller.onMainSave();
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Text _mark() {
    return Text(
      ' * ',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.errorColor,
      ),
    );
  }

  Widget titleRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('paisa'.tr, style: TextStyle(fontSize: 14)),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'cost'.tr,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
