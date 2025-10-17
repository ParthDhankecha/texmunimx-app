import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/utils/app_const.dart';

class CalculatorPdfViewScreen extends StatefulWidget {
  const CalculatorPdfViewScreen({super.key});

  @override
  State<CalculatorPdfViewScreen> createState() =>
      _CalculatorPdfViewScreenState();
}

class _CalculatorPdfViewScreenState extends State<CalculatorPdfViewScreen> {
  CalculatorController controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator PDF View'),
        actions: [
          TextButton(
            onPressed: () {
              controller.generateAndDownloadPdf();
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            //design details
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: Colors.black38, width: 0.50),
              ),
              child: Row(
                children: [
                  CustomNetworkImage(
                    imageUrl:
                        AppConst.imageBaseUrl +
                        (controller.selectedDesign.value?.designImage ?? ''),
                    height: 56,
                    width: 56,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Design: ${controller.selectedDesign.value?.designName ?? 'N/A'} (${controller.selectedDesign.value?.designNumber ?? 'N/A'})',
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //wrap details
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: Colors.black38, width: 0.50),
              ),
              child: Column(
                children: [
                  Row(children: [Text('wrap'.tr, style: titleStyle)]),

                  SizedBox(height: 10),
                  buildKeyValueRow(
                    'quality'.tr,
                    controller.qualityCont.text.trim().toString(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildKeyValueRow(
                          'denier'.tr,
                          controller.denierCont.text.trim().toString(),
                        ),
                      ),
                      Expanded(
                        child: buildKeyValueRow(
                          'tar'.tr,
                          controller.tarCont.text.trim().toString(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildKeyValueRow(
                          'meter'.tr,
                          controller.meterCont.text.trim().toString(),
                        ),
                      ),
                      Expanded(
                        child: buildKeyValueRow(
                          'rate_per_kg'.tr,
                          controller.ratePerKgCont.text.trim().toString(),
                        ),
                      ),
                    ],
                  ),
                  buildTotalRow(
                    'total_warp_cost'.tr,
                    controller.warpCost.value.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //weft details
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),

                border: Border.all(color: Colors.black38, width: 0.50),
              ),
              child: Column(
                children: [
                  Row(children: [Text('weft'.tr, style: titleStyle)]),

                  SizedBox(height: 10),
                  ...controller.weftList.map((element) {
                    if (element.rate == null || element.rate == 0) {
                      return SizedBox.shrink();
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildKeyValueRow(
                                'feeder'.tr,
                                element.feeder,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildKeyValueRow(
                                'quality'.tr,
                                element.quality?.trim() ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: buildKeyValueRow(
                                'denier'.tr,
                                element.denier?.toStringAsFixed(2) ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: buildKeyValueRow(
                                'Pick'.tr,
                                element.pick?.toStringAsFixed(2) ?? 'N/A',
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: buildKeyValueRow(
                                'panno'.tr,
                                element.panno?.toStringAsFixed(2) ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: buildKeyValueRow(
                                'meter'.tr,
                                element.meter?.toStringAsFixed(2) ?? 'N/A',
                              ),
                            ),
                            Expanded(
                              child: buildKeyValueRow(
                                'rate'.tr,
                                element.rate?.toStringAsFixed(2) ?? 'N/A',
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 8),
                      ],
                    );
                  }),
                  buildTotalRow(
                    'total_weft_cost'.tr,
                    controller.totalWeftCost.toStringAsFixed(2),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //labour details
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38, width: 0.50),
              ),
              child: Column(
                children: [
                  Row(children: [Text('labour'.tr, style: titleStyle)]),
                  buildKeyValueRow(
                    'design_card'.tr,
                    controller.designCardCont.text,
                  ),
                  SizedBox(height: 10),
                  buildKeyValueRow('paisa'.tr, 'cost'.tr),

                  ...controller.labourCostList.map(
                    (element) => Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: buildKeyValueRow(
                                element.paisa.toStringAsFixed(2),
                                element.cost.toStringAsFixed(2),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKeyValueRow(String key, String value) {
    return Container(
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(2),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black26, width: 0.10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(key, style: normalTextStyle.copyWith(fontSize: 12)),
            Text(
              value,
              style: normalTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTotalRow(String key, String value) {
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.circular(),
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.black26, width: 0.50),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(key, style: bodyStyle.copyWith(color: Colors.black54)),
            Text(value, style: bodyStyle.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget titleCell(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: Colors.grey.shade300,
          border: Border.all(color: Colors.black26, width: 0.50),
        ),
        child: Text(
          title,
          style: bodyStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  Widget valueCell(String value, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.black26, width: 0.50),
        ),
        child: Text(value, style: bodyStyle.copyWith(fontSize: 12)),
      ),
    );
  }
}
