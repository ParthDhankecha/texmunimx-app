import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/order_history_response.dart';
import 'package:texmunimx/screens/purchase_order/order_history/widget/order_details_sheet.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';

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
    log('order history: ${widget.order.status}');
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
              _buildRow(
                title: 'user',
                value: widget.order.userId.capitalizeFirst!,
              ),
              _buildRow(
                title: 'moved_by',
                value: widget.order.movedBy.capitalizeFirst!,
              ),
              if (widget.order.quantity > 0)
                _buildRow(
                  title:
                      "${widget.order.status == 'inProcess'
                          ? 'pending'.tr
                          : widget.order.status == "readyToDispatch"
                          ? 'ready_to_dispatch'.tr
                          : widget.order.status == "delivered"
                          ? 'delivered'.tr
                          : widget.order.status == "delivered"
                          ? 'delivered'.tr
                          : ''} ${'quantity'.tr}",
                  value: widget.order.quantity.toString(),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return OrderHistoryDetailsSheet(order: widget.order);
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainColor.withAlpha(22),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text('view_details'.tr),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
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
