import 'package:flutter/material.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/utils/app_const.dart';
import 'package:textile_po/utils/formate_dobble.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrderModel order;

  const PurchaseOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top section of the card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Design/Party image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    order.designId.isNotEmpty
                        ? AppConst.imageBaseUrl +
                              order.designId.first.designImage
                        : 'https://placehold.co/100x100',
                    width: 60,
                    height: 60,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.partyId.isNotEmpty
                            ? order.partyId.first.partyName
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        order.partyId.isNotEmpty
                            ? order.partyId.first.partyNumber
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
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
                    child: Text(
                      order.isCompleted ? 'Completed' : 'Pending',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Bottom section with progress details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProgressItem('Pending', '${order.pending}'),
                _buildProgressItem('Quantity', '${order.quantity}'),
                _buildProgressItem('Rate', formatDouble(order.rate)),
                _buildProgressItem('Panna', formatDouble(order.panna)),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          quantity.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
