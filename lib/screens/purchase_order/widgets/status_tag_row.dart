import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/utils/app_colors.dart';

class StatusTagRow extends StatelessWidget {
  const StatusTagRow({super.key, required this.order, this.type = 'pending'});

  final PurchaseOrderModel order;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (order.isJobPo) ...[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 108, 117, 125),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MyText(
                'job_po'.tr,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
        if (order.isHighPriority ?? false) ...[
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 220, 53, 69),
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
            color: order.orderType == 'sari'
                ? Color.fromARGB(255, 13, 202, 240)
                : Color.fromARGB(255, 255, 193, 7),
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

        // Status tag
      ],
    );
  }
}
