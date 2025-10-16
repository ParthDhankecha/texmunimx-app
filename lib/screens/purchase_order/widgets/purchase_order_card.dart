import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:texmunimx/screens/purchase_order/create_po/create_purchase_order.dart';
import 'package:texmunimx/screens/purchase_order/order_history/order_history_list.dart';
import 'package:texmunimx/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/formate_double.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderModel order;
  final Design design;
  final Party party;
  final bool isEditvisible;

  const PurchaseOrderCard({
    super.key,
    required this.order,
    required this.design,
    required this.party,
    this.isEditvisible = true,
  });

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
                // Design/Party image
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8.0),
                //   child: Image.network(
                //     order.designId.isNotEmpty
                //         ? AppConst.imageBaseUrl + design.designImage
                //         : 'https://placehold.co/100x100',
                //     width: 50,
                //     height: 50,
                //     fit: BoxFit.cover,
                //     errorBuilder: (context, error, stackTrace) => Container(
                //       width: 60,
                //       height: 60,
                //       color: Colors.grey[200],
                //       child: Image.network(
                //         AppConst.imageBaseUrl + AppConst.placeHolderImage,
                //       ),
                //     ),
                //   ),
                // ),
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
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('party_name'),
                Text(
                  order.partyId.isNotEmpty ? party.partyName : 'N/A',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                MyText('party_number'),
                Text(
                  order.partyId.isNotEmpty ? party.partyNumber : 'N/A',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('panna'),
                Text(
                  formatDouble(order.panna),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('order_quantity'),
                Text(
                  '${order.matching?.quantity ?? "0"}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('pending_quantity'),
                Text(
                  '${order.matching?.pending ?? "0"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('note'),
                Text(order.note ?? 'N/A', style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => UpdateStatusBottomSheet(
                        po: order,
                        orderQuantity: order.matching?.quantity ?? 0,
                        pendingQuantity: order.matching?.pending ?? 0,
                        moveTo: OrderStatus.inProcess,
                        currentStatus: OrderStatus.pending,
                        purchaseId: order.id,
                        firmId: '',
                        userId: '',
                        isJobPo: order.isJobPo,
                        machinObjId: order.matching?.id,
                      ),
                    );
                  },
                  child: MyText('in_progress'),
                ),
                isEditvisible
                    ? TextButton(
                        onPressed: () {
                          Get.to(() => CreatePurchaseOrder(po: order));
                        },
                        child: MyText('edit'),
                      )
                    : SizedBox.shrink(),

                TextButton(
                  onPressed: () {
                    Get.to(() => OrderHistoryListScreen(id: order.id));
                  },
                  child: MyText('history'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
