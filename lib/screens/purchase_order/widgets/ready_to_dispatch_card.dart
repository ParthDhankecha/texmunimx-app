import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:texmunimx/screens/purchase_order/order_history/order_history_list.dart';
import 'package:texmunimx/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/formate_double.dart';

class ReadyToDispatchCard extends StatefulWidget {
  final PurchaseOrderModel order;
  final Design design;
  final Party party;

  const ReadyToDispatchCard({
    super.key,
    required this.order,
    required this.design,
    required this.party,
  });

  @override
  State<ReadyToDispatchCard> createState() => _ReadyToDispatchCardState();
}

class _ReadyToDispatchCardState extends State<ReadyToDispatchCard> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();

  @override
  Widget build(BuildContext context) {
    log('ready_to_dispatch id - ${widget.order.readyToDispatch?.id}');
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            StatusTagRow(order: widget.order, type: 'ready_to_dispatch'),
            // Top section of the card
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Design/Party image
                CustomNetworkImage(
                  imageUrl: AppConst.imageBaseUrl + widget.design.designImage,
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
                        widget.order.designId.isNotEmpty
                            ? widget.design.designName
                            : 'N/A',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.order.poNumber.isNotEmpty
                      ? widget.order.poNumber
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('customer', append: ' : '),
                Text(
                  widget.order.partyId.isNotEmpty
                      ? widget.party.partyName
                      : 'N/A',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                MyText('customer_id', append: ' : '),
                Text(
                  widget.order.partyId.isNotEmpty
                      ? widget.party.partyNumber
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
                  formatDouble(widget.order.panna),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('firm_name', append: ' : '),
                Text(
                  controller.firmNameById(
                    widget.order.readyToDispatch?.firmId ?? '',
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('moved_by', append: ' : '),
                Text(
                  controller
                      .getMovedUserById(
                        widget.order.readyToDispatch?.movedBy ?? '',
                      )
                      .capitalizeFirst!,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('machine_no', append: ' : '),
                Text(
                  widget.order.readyToDispatch?.machineNo ?? 'N/A',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('order_quantity', append: ' : '),
                Text(
                  '${widget.order.matching?.quantity ?? "0"}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('pending_quantity', append: ' : '),
                Text(
                  '${widget.order.matching?.pending ?? "0"}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('ready_to_dispatch_quantity', append: ' : '),
                Text(
                  '${widget.order.readyToDispatch?.quantity ?? 0}',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyText('note', append: ' : '),
                Text(
                  widget.order.readyToDispatch?.remarks ?? 'N/A',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomBtn(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,

                      builder: (context) => UpdateStatusBottomSheet(
                        po: widget.order,
                        orderQuantity: widget.order.matching?.quantity ?? 0,
                        pendingQuantity:
                            widget.order.readyToDispatch?.quantity ?? 0,
                        moveTo: OrderStatus.inProcess,
                        currentStatus: OrderStatus.readyToDispatch,
                        purchaseId: widget.order.id,
                        quantityTitle: 'Ready To Dispatch'.tr,
                        firmId: widget.order.readyToDispatch?.firmId ?? '',
                        userId: widget.order.readyToDispatch?.userId ?? '',
                        machineNo:
                            widget.order.readyToDispatch?.machineNo ?? '',
                      ),
                    );
                  },
                  title: 'in_progress'.tr,
                  isOutline: true,
                  isSmall: true,
                ),
                SizedBox(width: 8),

                CustomBtn(
                  isOutline: true,
                  isSmall: true,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => UpdateStatusBottomSheet(
                        po: widget.order,
                        orderQuantity: widget.order.matching?.quantity ?? 0,
                        pendingQuantity:
                            widget.order.readyToDispatch?.quantity ?? 0,
                        moveTo: OrderStatus.delivered,
                        currentStatus: OrderStatus.readyToDispatch,
                        purchaseId: widget.order.id,
                        quantityTitle: 'Ready To Dispatch'.tr,
                        firmId: widget.order.readyToDispatch?.firmId ?? '',
                        userId: widget.order.readyToDispatch?.userId ?? '',
                        machineNo:
                            widget.order.readyToDispatch?.machineNo ?? '',
                      ),
                    );
                  },
                  title: 'completed'.tr,
                ),
                SizedBox(width: 8),
                CustomBtn(
                  isOutline: true,
                  isSmall: true,
                  onTap: () {
                    Get.to(() => OrderHistoryListScreen(id: widget.order.id));
                  },
                  title: 'history'.tr,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
