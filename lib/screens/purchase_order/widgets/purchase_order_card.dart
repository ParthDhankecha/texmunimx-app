import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/models/order_status_enum.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/formate_double.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseOrderCard({super.key, required this.order});

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
            // Top section of the card
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Design/Party image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    order.designId.isNotEmpty
                        ? AppConst.imageBaseUrl +
                              order.designId.first.designImage
                        : 'https://placehold.co/100x100',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, color: Colors.grey),
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
                        order.designId.isNotEmpty
                            ? order.designId.first.designName
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status tag
                Container(
                  decoration: BoxDecoration(
                    color: order.isCompleted ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: MyText(
                      'pending',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('customer'),
                Text(
                  order.partyId.isNotEmpty
                      ? order.partyId.first.partyName
                      : 'N/A',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                MyText('customer_id'),
                Text(
                  order.partyId.isNotEmpty
                      ? order.partyId.first.partyNumber
                      : 'N/A',
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
                MyText('rate'),
                Text(
                  formatDouble(order.rate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Divider(),
            // Bottom section with progress details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressItem('pending', '${order.pending}'),
                _buildProgressItem('quantity', '${order.quantity}'),
                _buildProgressItem(
                  'in_progress',
                  '${order.inProcess?.quantity ?? 0}',
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
                    // Get.bottomSheet(
                    //   UpdateStatusBottomSheet(
                    //     orderQuantity: order.quantity,
                    //     pendingQuantity: order.pending,
                    //     moveTo: 'In Progress',
                    //     firms: [],
                    //     users: [],
                    //   ),
                    // );
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

  // Helper method to build progress indicators
  Widget _buildProgressItem(String title, String quantity) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MyText(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
        const SizedBox(height: 4),
        Text(
          quantity.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
