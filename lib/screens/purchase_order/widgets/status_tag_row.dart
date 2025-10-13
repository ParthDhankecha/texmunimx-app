import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/models/purchase_order_list_response.dart';
import 'package:textile_po/utils/app_colors.dart';

class StatusTagRow extends StatelessWidget {
  const StatusTagRow({super.key, required this.order, this.type = 'pending'});

  final PurchaseOrderModel order;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (order.isHighPriority ?? false) ...[
          Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MyText(
                'high_priority'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        if (order.orderType == 'sari') ...[
          Container(
            decoration: BoxDecoration(
              color: AppColors.mainColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MyText(
                order.matching?.mLabel ?? 'N/A',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: order.orderType == 'sari' ? Colors.blueGrey : Colors.blue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: MyText(
              order.orderType.capitalizeFirst ?? 'N/A',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: type == 'delivered' ? Colors.grey : Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: MyText(
              type,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        SizedBox(width: 8),

        // Status tag
      ],
    );
  }
}
