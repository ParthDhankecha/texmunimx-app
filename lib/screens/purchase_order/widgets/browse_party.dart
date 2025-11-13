import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/screens/party/party_list_screen.dart';

class BrowseParty extends StatelessWidget {
  const BrowseParty({super.key, required this.controller});

  final PurchaseOrderController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),

      child: Obx(
        () => Column(
          children: [
            Row(
              children: [
                Text('Party  Details', style: bodyStyle),
                SizedBox(width: 6),
                RedMark(),
              ],
            ),
            Row(
              children: [
                Text(
                  controller.selectedParty.value != null
                      ? controller
                                .selectedParty
                                .value!
                                .partyName
                                .capitalizeFirst ??
                            ''
                      : 'Select Party',
                  style: titleStyle.copyWith(fontSize: 22),
                ),
              ],
            ),
            SizedBox(height: 8),
            controller.selectedParty.value != null
                ? Row(
                    children: [
                      Text('Party No: ', style: normalTextStyle.copyWith()),
                      Text(
                        controller.selectedParty.value?.partyNumber ?? '',
                        style: titleStyle.copyWith(),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 8),
            controller.selectedParty.value != null
                ? Row(
                    children: [
                      Text('Phone: ', style: normalTextStyle.copyWith()),
                      Text(
                        controller.selectedParty.value?.mobile ?? '',
                        style: titleStyle.copyWith(),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: CustomBtn(
                    title: 'Browse Party',
                    isOutline: true,
                    onTap: () {
                      Get.to(() => PartyListScreen(openForSelect: true));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
