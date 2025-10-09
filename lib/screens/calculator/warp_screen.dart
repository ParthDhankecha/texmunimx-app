import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/calculator_controller.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/formate_double.dart';

class WarpScreen extends StatefulWidget {
  const WarpScreen({super.key});

  @override
  State<WarpScreen> createState() => _WarpScreenState();
}

class _WarpScreenState extends State<WarpScreen> {
  CalculatorController controller = Get.find<CalculatorController>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    Text('total_warp_cost'.tr, style: bodyStyle),
                    Text(' (₹)'),
                  ],
                ),

                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Obx(
                      () => Text(
                        formatDouble(controller.warpCost.value),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //quality
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('quality'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    textEditingController: controller.qualityCont,
                    hintText: 'quality'.tr,
                    onTextChange: (value) {},
                    textInputType: TextInputType.text,
                    onValidator: (value) {
                      if (value!.isEmpty) {
                        return 'quality_required'.tr;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            //denier
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('denier'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'denier'.tr,
                    textEditingController: controller.denierCont,

                    onTextChange: (value) {
                      double val = double.tryParse(value) ?? 0;
                      controller.setDenier = val;
                      controller.calculateWarpCost();
                    },
                    textInputType: TextInputType.number,
                    onValidator: (value) {
                      if (value!.isEmpty) {
                        return 'denier_required'.tr;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            //Tar
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('tar'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'tar'.tr,
                    textEditingController: controller.tarCont,

                    onTextChange: (value) {
                      double val = double.tryParse(value) ?? 0;
                      controller.setTar = val;
                      controller.calculateWarpCost();
                    },
                    textInputType: TextInputType.number,
                    onValidator: (value) {
                      if (value!.isEmpty) {
                        return 'tar_required'.tr;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),

            //Tar
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('meter'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'meter'.tr,
                    textEditingController: controller.meterCont,

                    onTextChange: (value) {
                      double val = double.tryParse(value) ?? 0;
                      controller.setMeter = val;
                      controller.calculateWarpCost();
                    },
                    textInputType: TextInputType.number,
                    onValidator: (value) {
                      if (value!.isEmpty) {
                        return 'meter_required'.tr;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            //rate
            //Tar
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text('rate_per_kg'.tr, style: bodyStyle),
                      _mark(),
                    ],
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: InputField(
                    hintText: 'rate_per_kg'.tr,
                    textEditingController: controller.ratePerKgCont,

                    onTextChange: (value) {
                      double val = double.tryParse(value) ?? 0;
                      controller.setRatePerKg = val;
                      controller.calculateWarpCost();
                    },
                    textInputType: TextInputType.number,
                    onValidator: (value) {
                      if (value!.isEmpty) {
                        return 'rate_per_kg_required'.tr;
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CustomBtn(
            //       title: 'save_and_next'.tr,
            //       onTap: () {
            //         if (formKey.currentState!.validate()) {
            //           controller.onSaveWarp();
            //         } else {}
            //       },
            //     ),
            //   ],
            // ),
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
}
