import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_icon_btn.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:texmunimx/screens/purchase_order/order_history/order_history_list.dart';
import 'package:texmunimx/screens/purchase_order/widgets/build_value_row.dart';
import 'package:texmunimx/screens/purchase_order/widgets/notes_row.dart';
import 'package:texmunimx/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';
import 'package:texmunimx/utils/formate_double.dart';
import 'package:texmunimx/utils/list_helper.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class InProcessCard extends StatefulWidget {
  final PurchaseOrderModel order;
  final Design design;
  final Party party;
  final String jobUser;

  const InProcessCard({
    super.key,
    required this.order,
    required this.design,
    required this.party,
    required this.jobUser,
  });

  @override
  State<InProcessCard> createState() => _InProcessCardState();
}

class _InProcessCardState extends State<InProcessCard> {
  final PurchaseOrderController controller =
      Get.find<PurchaseOrderController>();

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
            StatusTagRow(order: widget.order, type: 'in_progress'),
            // Top section of the card
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Design image
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

            BuildValueRow(
              title: 'order_date',
              value: widget.order.orderDate?.ddmmyyFormat ?? '',
              isVisible: widget.order.orderDate != null,
            ),

            BuildValueRow(
              title: 'delivery_date',
              value: widget.order.deliveryDate?.ddmmyyFormat ?? 'N/A',
              isVisible: widget.order.deliveryDate != null,
              valueColor:
                  (widget.order.deliveryDate
                              ?.difference(DateTime.now())
                              .inDays ??
                          0) <
                      3
                  ? Colors.red
                  : null,
            ),

            BuildValueRow(
              title: 'party_name',
              value: widget.order.partyId.isNotEmpty
                  ? widget.party.partyName
                  : 'N/A',
            ),

            BuildValueRow(
              title: 'party_number',
              value: widget.order.partyId.isNotEmpty
                  ? widget.party.partyNumber
                  : 'N/A',
            ),
            BuildValueRow(
              title: 'panna',
              value: formatDouble(widget.order.panna),
            ),

            BuildValueRow(
              title: 'firm_name',
              value: controller.firmNameById(
                widget.order.inProcess?.firmId ?? '',
              ),
            ),

            BuildValueRow(
              title: 'moved_by',
              value: controller
                  .getMovedUserById(widget.order.inProcess?.movedBy ?? '')
                  .capitalizeFirst!,
            ),

            BuildValueRow(
              title: 'machine_no',
              value: widget.order.inProcess?.machineNo ?? 'N/A',
            ),

            BuildValueRow(
              title: 'job_user',
              value: widget.jobUser,
              isVisible:
                  widget.order.isJobPo &&
                  (Get.find<Sharedprefs>().userRole == 1 ||
                      Get.find<Sharedprefs>().userRole == 2),
            ),

            BuildValueRow(
              title: 'order_quantity',
              value: widget.order.orderType == 'sari'
                  ? '${widget.order.matching?.colors?.quantity ?? "0"}'
                  : widget.order.isJobPo
                  ? '${widget.order.jobUser?.quantity ?? "0"}'
                  : '${widget.order.quantity}',
            ),

            BuildValueRow(
              title: 'in_process_quantity',
              value: '${widget.order.inProcess?.quantity ?? 0}',
            ),

            NotesRow(notes: widget.order.inProcess?.remarks ?? 'N/A'),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (!widget.order.hideUposBtns)
                      CustomIconBtn(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => UpdateStatusBottomSheet(
                              po: widget.order,
                              moveTo: OrderStatus.pending,
                              currentStatus: OrderStatus.inProcess,
                            ),
                          );
                        },
                        title: 'pending'.tr,
                        isSmall: true,
                        isOutline: true,
                        icon: 'move',
                      ),
                    SizedBox(width: 8),

                    if (!widget.order.hideUposBtns)
                      CustomIconBtn(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => UpdateStatusBottomSheet(
                              po: widget.order,
                              // orderQuantity: widget.order.quantity,
                              //   pendingQuantity:
                              //      widget.order.inProcess?.quantity ?? 0,
                              moveTo: OrderStatus.readyToDispatch,
                              currentStatus: OrderStatus.inProcess,
                              //  purchaseId: widget.order.id,
                              //  quantityTitle: 'In Progress',
                              //   firmId: widget.order.inProcess?.firmId ?? '',
                              //   userId: widget.order.inProcess?.userId ?? '',
                              //   machineNo: widget.order.inProcess?.machineNo ?? '',
                            ),
                          );
                        },
                        title: 'ready_to_dispatch'.tr,
                        isSmall: true,
                        icon: 'move',
                        isOutline: true,
                      ),
                    SizedBox(width: 8),
                    CustomIconBtn(
                      onTap: () {
                        Get.to(
                          () => OrderHistoryListScreen(id: widget.order.id),
                        );
                      },
                      title: 'history'.tr,
                      icon: 'history',
                      isOutline: true,
                      isSmall: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
