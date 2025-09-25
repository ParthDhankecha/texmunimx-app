import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/calculator_controller.dart';
import 'package:textile_po/screens/calculator/labour/labour_cost_list.dart';
import 'package:textile_po/screens/calculator/warp_screen.dart';
import 'package:textile_po/screens/calculator/weft/weft_screen.dart';
import 'package:textile_po/screens/calculator/widgets/custom_tabs.dart';
import 'package:textile_po/screens/calculator/widgets/select_design.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  CalculatorController controller = Get.find<CalculatorController>();

  List<Widget> screenList = [WarpScreen()];
  @override
  void initState() {
    super.initState();
    controller.setDesign = null;
    controller.setIndex = 0;
    controller.warpCost.value = 0;
    controller.enterPaisa.value = 0.0;
    // controller.generateDefaultBoxes();
    controller.loadCalculatorData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.setDesign = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('calculator'.tr), elevation: 6),
      body: Column(
        children: [
          //select design
          SelectDesign(controller: controller),
          //tabs
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
            child: CustomTabs(),
          ),

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
                  Obx(
                    () => Visibility(
                      visible: controller.selectedTab.value == 0,
                      child: WarpScreen(),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.selectedTab.value == 1,
                      child: WeftScreen(),
                    ),
                  ),
                  Obx(
                    () => Visibility(
                      visible: controller.selectedTab.value == 2,
                      child: LabourCostList(),
                    ),
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
