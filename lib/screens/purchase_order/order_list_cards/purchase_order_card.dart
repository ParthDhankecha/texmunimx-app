import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_icon_btn.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:texmunimx/screens/purchase_order/create_po/create_purchase_order.dart';
import 'package:texmunimx/screens/purchase_order/order_history/order_history_list.dart';
import 'package:texmunimx/screens/purchase_order/widgets/build_value_row.dart';
import 'package:texmunimx/screens/purchase_order/widgets/notes_row.dart';
import 'package:texmunimx/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';
import 'package:texmunimx/utils/formate_double.dart';
import 'package:texmunimx/utils/list_helper.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderModel order;
  final Design design;
  final Party party;
  final String? jobUser;
  final bool isEditvisible;

  PurchaseOrderCard({
    super.key,
    required this.order,
    required this.design,
    required this.party,
    this.isEditvisible = true,
    this.jobUser,
  });

  PurchaseOrderController purchaseOrderController =
      Get.find<PurchaseOrderController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StatusTagRow(order: order),
            // Top section of the card
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomNetworkImage(
                  imageUrl: AppConst.imageBaseUrl + design.designImage,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 16),
                // Party Name and Company
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.designId.isNotEmpty ? design.designName : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  order.poNumber.isNotEmpty ? order.poNumber : 'N/A',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            BuildValueRow(
              title: 'order_date',
              value: order.orderDate?.ddmmyyFormat ?? '',
              isVisible: order.orderDate != null,
            ),

            BuildValueRow(
              title: 'delivery_date',
              value: order.deliveryDate?.ddmmyyFormat ?? 'N/A',
              isVisible: order.deliveryDate != null,
              valueColor:
                  (order.deliveryDate?.difference(DateTime.now()).inDays ?? 0) <
                      3
                  ? Colors.red
                  : null,
            ),

            BuildValueRow(
              title: 'party_name',
              value: order.partyId.isNotEmpty ? party.partyName : 'N/A',
            ),

            BuildValueRow(
              title: 'party_number',
              value: order.partyId.isNotEmpty ? party.partyNumber : 'N/A',
            ),
            BuildValueRow(title: 'panna', value: formatDouble(order.panna)),

            BuildValueRow(
              title: 'job_user',
              value: jobUser ?? 'N/A',
              isVisible:
                  order.isJobPo &&
                  (Get.find<Sharedprefs>().userRole == 1 ||
                      Get.find<Sharedprefs>().userRole == 2),
            ),

            order.orderType != 'sari'
                ? BuildValueRow(
                    title: 'order_quantity',
                    value: order.isJobPo
                        ? '${order.jobUser?.quantity ?? "0"}'
                        : '${order.matching?.quantity ?? "0"}',

                    isVisible: !order.isMasterEntry,
                  )
                : BuildValueRow(
                    //if sari
                    title: 'order_quantity',
                    value: order.isJobPo
                        ? '${order.jobUser?.quantity ?? "0"}'
                        : '${order.matching?.colors?.quantity ?? "0"}',

                    isVisible: !order.isMasterEntry,
                  ),
            order.orderType != 'sari'
                ? BuildValueRow(
                    title: 'pending_quantity'.tr,
                    value: order.isJobPo
                        ? '${order.jobUser?.pending ?? "0"}'
                        : '${order.matching?.pending ?? "0"}',
                    isVisible: !order.isMasterEntry,
                  )
                : BuildValueRow(
                    title: 'pending_quantity'.tr,
                    value: order.isJobPo
                        ? '${order.jobUser?.pending ?? "0"}'
                        : '${order.matching?.colors?.pending ?? "0"}',
                    isVisible: !order.isMasterEntry,
                  ),

            NotesRow(notes: order.note ?? 'N/A'),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!order.isMasterEntry)
                  CustomIconBtn(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        builder: (context) => UpdateStatusBottomSheet(
                          po: order,
                          moveTo: OrderStatus.inProcess,
                          currentStatus: OrderStatus.pending,
                        ),
                      );
                    },
                    title: 'in_progress'.tr,
                    isSmall: true,
                    icon: 'move',
                    isOutline: true,
                  ),
                SizedBox(width: 10),
                isEditvisible
                    ? CustomIconBtn(
                        onTap: () {
                          Get.to(() => CreatePurchaseOrder(po: order));
                        },
                        icon: 'edit',
                        title: 'edit'.tr,
                        isSmall: true,
                        isOutline: true,
                      )
                    : SizedBox.shrink(),
                isEditvisible ? SizedBox(width: 10) : SizedBox.shrink(),
                CustomIconBtn(
                  onTap: () {
                    Get.to(() => OrderHistoryListScreen(id: order.id));
                  },
                  icon: 'history',
                  title: 'history'.tr,
                  isSmall: true,
                  isOutline: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
