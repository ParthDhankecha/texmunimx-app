import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_icon_btn.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/change_order_status/change_order_status_screen.dart';
import 'package:texmunimx/screens/purchase_order/order_history/order_history_list.dart';
import 'package:texmunimx/screens/purchase_order/widgets/notes_row.dart';
import 'package:texmunimx/screens/purchase_order/widgets/status_tag_row.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/date_formate_extension.dart';
import 'package:texmunimx/utils/formate_double.dart';
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

  Widget _buildValueRow({
    required String title,
    required String value,
    Color? valueColor,
    bool isVisible = true,
  }) {
    return isVisible
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title, append: ' : '),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: valueColor ?? Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],
          )
        : SizedBox.shrink();
  }

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

            _buildValueRow(
              title: 'delivery_date',
              value: widget.order.deliveryDate?.ddmmyyFormat ?? 'N/A',
              isVisible: widget.order.deliveryDate != null,
            ),

            _buildValueRow(
              title: 'party_name',
              value: widget.order.partyId.isNotEmpty
                  ? widget.party.partyName
                  : 'N/A',
            ),

            _buildValueRow(
              title: 'party_number',
              value: widget.order.partyId.isNotEmpty
                  ? widget.party.partyNumber
                  : 'N/A',
            ),
            _buildValueRow(
              title: 'panna',
              value: formatDouble(widget.order.panna),
            ),

            _buildValueRow(
              title: 'firm_name',
              value: controller.firmNameById(
                widget.order.inProcess?.firmId ?? '',
              ),
            ),

            _buildValueRow(
              title: 'moved_by',
              value: controller
                  .getMovedUserById(widget.order.inProcess?.movedBy ?? '')
                  .capitalizeFirst!,
            ),

            _buildValueRow(
              title: 'machine_no',
              value: widget.order.inProcess?.machineNo ?? 'N/A',
            ),

            _buildValueRow(
              title: 'job_user',
              value: widget.jobUser,
              isVisible:
                  widget.order.isJobPo &&
                  (Get.find<Sharedprefs>().userRole == 1 ||
                      Get.find<Sharedprefs>().userRole == 2),
            ),

            _buildValueRow(
              title: 'order_quantity',
              value: widget.order.isJobPo
                  ? '${widget.order.jobUser?.quantity ?? "0"}'
                  : '${widget.order.quantity}',
            ),

            _buildValueRow(
              title: 'in_process_quantity',
              value: '${widget.order.inProcess?.quantity ?? 0}',
            ),
            const SizedBox(height: 10),
            NotesRow(notes: widget.order.inProcess?.remarks ?? 'N/A'),

            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomIconBtn(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,

                        builder: (context) => UpdateStatusBottomSheet(
                          po: widget.order,
                          // orderQuantity: widget.order.quantity,
                          // pendingQuantity:
                          //        widget.order.inProcess?.quantity ?? 0,
                          moveTo: OrderStatus.pending,
                          currentStatus: OrderStatus.inProcess,
                          //  purchaseId: widget.order.id,
                          //  quantityTitle: 'In Progress',
                          //  firmId: widget.order.inProcess?.firmId ?? '',
                          //  userId: widget.order.inProcess?.userId ?? '',
                          //  machineNo: widget.order.inProcess?.machineNo ?? '',
                        ),
                      );
                    },
                    title: 'pending'.tr,
                    isSmall: true,
                    isOutline: true,
                    icon: 'move',
                  ),
                  SizedBox(width: 8),
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
                      Get.to(() => OrderHistoryListScreen(id: widget.order.id));
                    },
                    title: 'history'.tr,
                    icon: 'history',
                    isOutline: true,
                    isSmall: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
