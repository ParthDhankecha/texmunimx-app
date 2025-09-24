import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/formate_double.dart';

class DeliveredCard extends StatelessWidget {
  final PurchaseOrderModel order;

  const DeliveredCard({super.key, required this.order});

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
                        : AppConst.imageBaseUrl + AppConst.placeHolderImage,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 42,
                      height: 42,
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
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: MyText(
                      'completed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('customer', append: ' : '),
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
                MyText('customer_id', append: ' : '),
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
                MyText('panna', append: ' : '),
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
                MyText('rate', append: ' : '),
                Text(
                  formatDouble(order.rate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('firm_name', append: ' : '),
                Text(
                  order.delivered?.firmId.first.firmName ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('moved_by', append: ' : '),
                Text(
                  order.delivered?.movedBy.first.fullname ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('machine_no', append: ' : '),
                Text(
                  order.delivered?.machineNo ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Bottom section with progress details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressItem('pending'.tr, '${order.pending}'),
                _buildProgressItem('quantity'.tr, '${order.quantity}'),
                _buildProgressItem(
                  'delivered'.tr,
                  '${order.delivered?.quantity ?? 0}',
                ),
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

      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.black)),
        const SizedBox(height: 4),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
