import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/controllers/calculator_controller.dart';
import 'package:texmunimx/utils/app_colors.dart';

class CustomTabs extends StatelessWidget {
  CustomTabs({super.key});

  final CalculatorController controller = Get.find<CalculatorController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            tabItem(
              title: 'warp'.tr,
              isSelected: controller.selectedTab.value == 0,
              onChange: (isSelected) => controller.setIndex = 0,
            ),
            tabItem(
              title: 'weft'.tr,
              isSelected: controller.selectedTab.value == 1,
              onChange: (isSelected) => controller.setIndex = 1,
            ),
            tabItem(
              title: 'labour'.tr,
              isSelected: controller.selectedTab.value == 2,
              onChange: (isSelected) => controller.setIndex = 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget tabItem({
    required String title,
    required bool isSelected,
    required Function(bool isSelected) onChange,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onChange(!isSelected);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(8),
                )
              : BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
          child: Center(
            child: Text(
              title,
              style: titleStyle.copyWith(
                color: isSelected ? Colors.white : AppColors.mainColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
