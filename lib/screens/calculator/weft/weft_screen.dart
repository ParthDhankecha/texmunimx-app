import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/models/cal_weft_model.dart';
import 'package:texmunimx/screens/calculator/weft/weft_item_card.dart';
import 'package:texmunimx/utils/formate_double.dart';

class WeftScreen extends StatefulWidget {
  const WeftScreen({super.key});

  @override
  State<WeftScreen> createState() => _WeftScreenState();
}

class _WeftScreenState extends State<WeftScreen> {
  CalculatorController controller = Get.find<CalculatorController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  MyText('total_weft_cost', append: ' (₹)', style: bodyStyle),
                ],
              ),

              Container(
                padding: EdgeInsets.all(10),
                child: Obx(
                  () => Text(
                    formatDouble(controller.totalWeftCost.value),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        Obx(
          () => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.weftList.length,
            itemBuilder: (context, index) {
              CalWeftModel model = controller.weftList[index];
              return WeftItemCard(
                model: model,
                index: index,
                onRemove: () {
                  controller.removeBox(index);
                },
                onChangeQuality: (value) {
                  controller.weftList[index].quality = value;
                },
                onDenierChange: (value) {
                  controller.weftList[index].denier =
                      double.tryParse(value) ?? 0.0;
                  controller.calculateWeft();
                },
                onPickChange: (value) {
                  controller.weftList[index].pick =
                      double.tryParse(value) ?? 0.0;
                  controller.calculateWeft();
                },
                onPannoChange: (value) {
                  controller.weftList[index].panno =
                      double.tryParse(value) ?? 0.0;
                  controller.calculateWeft();
                },
                onRateChange: (value) {
                  controller.weftList[index].rate =
                      double.tryParse(value) ?? 0.0;
                  controller.calculateWeft();
                },
                onMeterChange: (value) {
                  controller.weftList[index].meter =
                      double.tryParse(value) ?? 0.0;
                  controller.calculateWeft();
                },
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
                  controller.addNewWeft();
                },
              ),
              // SizedBox(width: 20),
              // CustomBtn(
              //   title: 'save_and_next'.tr,
              //   onTap: () {
              //     controller.onSaveWeft();
              //   },
              // ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
