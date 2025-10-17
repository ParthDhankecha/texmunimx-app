import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/screens/calculator/calculator_pdf_view_screen.dart';
import 'package:texmunimx/screens/calculator/labour/labour_cost_list.dart';
import 'package:texmunimx/screens/calculator/warp_screen.dart';
import 'package:texmunimx/screens/calculator/weft/weft_screen.dart';
import 'package:texmunimx/screens/calculator/widgets/select_design.dart';
import 'package:texmunimx/screens/calculator/widgets/text_separator_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  CalculatorController controller = Get.find<CalculatorController>();

  @override
  void initState() {
    super.initState();
    controller.setDesign = null;
    controller.setIndex = 0;
    controller.warpCost.value = 0;
    controller.enterPaisa.value = 0.0;
    // controller.generateDefaultBoxes();
    controller.loadCalculatorData();
    controller.generateDefaultBoxes();
  }

  @override
  void dispose() {
    super.dispose();
    controller.setDesign = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('calculator'.tr),
        elevation: 6,
        actions: [
          TextButton(
            onPressed: () {
              if (controller.pdfValidations()) {
                Get.to(() => const CalculatorPdfViewScreen());
              }
            },
            child: Text('pdf'.tr),
          ),
        ],
      ),
      body: Column(
        children: [
          //select design
          SelectDesign(controller: controller),

          //tab wise form
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //show loading indicator
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
                  Divider(),
                  Column(
                    children: [
                      WarpScreen(),
                      TextSeparator(color: Colors.black),
                      WeftScreen(),
                      TextSeparator(color: Colors.black),

                      LabourCostList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
