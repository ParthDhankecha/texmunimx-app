import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/controllers/calculator_controller.dart';
import 'package:textile_po/screens/create_design/design_list_screen.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/app_const.dart';

class SelectDesign extends StatelessWidget {
  const SelectDesign({super.key, required this.controller});

  final CalculatorController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Design/Party image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    AppConst.imageBaseUrl +
                        (controller.selectedDesign.value?.designImage ?? ''),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: Image.network(
                        AppConst.imageBaseUrl + AppConst.placeHolderImage,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                controller.selectedDesign.value != null
                    ? Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                controller.selectedDesign.value?.designName ??
                                    '',
                                style: titleStyle,
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                Get.to(
                                  () =>
                                      DesignListScreen(openForSelection: true),
                                );
                              },
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: AppColors.mainColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    : CustomBtn(
                        title: 'select_design'.tr,
                        onTap: () {
                          Get.to(
                            () => DesignListScreen(openForSelection: true),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
