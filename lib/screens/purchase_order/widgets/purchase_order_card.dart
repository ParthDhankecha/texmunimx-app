import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/models/order_status_enum.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/models/purchase_order_options_response.dart';
import 'package:textile_po/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:textile_po/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/formate_double.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderModel order;
  final Design design;
  final Party party;

  const PurchaseOrderCard({
    super.key,
    required this.order,
    required this.design,
    required this.party,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    order.designId.isNotEmpty
                        ? AppConst.imageBaseUrl + design.designImage
                        : 'https://placehold.co/100x100',
                    width: 50,
                    height: 50,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      builder: (context) => UpdateStatusBottomSheet(
                        orderQuantity: order.quantity,
                        pendingQuantity: order.pending,
                        moveTo: OrderStatus.inProcess,
                        currentStatus: OrderStatus.pending,
                        purchaseId: order.id,
                        firmId: '',
                        userId: '',
                      ),
                    );
                  },
                  child: MyText('in_progress'),
                ),
                TextButton(onPressed: () {}, child: MyText('edit')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
