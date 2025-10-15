import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/models/order_history_response.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/date_formate_extension.dart';

class OrderHistoryCard extends StatefulWidget {
  const OrderHistoryCard({super.key, required this.order});

  final OrderHistory order;

  @override
  State<OrderHistoryCard> createState() => _OrderHistoryCardState();
}

class _OrderHistoryCardState extends State<OrderHistoryCard> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();
  @override
  Widget build(BuildContext context) {
    log('order history: ${widget.order.userId}');
    return Padding(
      padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildRow(
                title: 'updated_at',
                value: widget.order.eventDate.ddMMyyyyhhmma,
              ),
              _buildRow(title: 'user', value: widget.order.userId),
              _buildRow(
                title: 'moved_by',
                value: widget.order.movedBy.capitalizeFirst!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title.tr),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.mainColor,
          ),
        ),
      ],
    );
  }
}
