import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/screens/create_design/design_list_screen.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';

class BrowseDesign extends StatelessWidget {
  const BrowseDesign({super.key, required this.controller});

  final PurchaseOrderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text('design_details'.tr, style: bodyStyle),
              SizedBox(width: 4),
              RedMark(),
            ],
          ),

          SizedBox(height: 8),
          Obx(
            () => controller.selectedDesign.value != null
                ? Row(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: CustomNetworkImage(
                                imageUrl:
                                    controller
                                        .selectedDesign
                                        .value!
                                        .designImage
                                        .isNotEmpty
                                    ? AppConst.imageBaseUrl +
                                          controller
                                              .selectedDesign
                                              .value!
                                              .designImage
                                    : AppConst.imageBaseUrl +
                                          AppConst.placeHolderImage,
                              ),
                            ),

                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black54,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              left: 8,
                              bottom: 6,
                              child: Text(
                                controller.selectedDesign.value!.designName,
                                style: titleStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    height: 140,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate,
                            size: 76,
                            color: Colors.grey,
                          ),
                          Text(
                            'select_design'.tr,
                            style: TextStyle(
                              fontSize: 14,

                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),

          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CustomBtn(
                  title: 'browse_design'.tr,
                  isOutline: true,
                  onTap: () {
                    Get.to(() => DesignListScreen(openForSelection: true));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
