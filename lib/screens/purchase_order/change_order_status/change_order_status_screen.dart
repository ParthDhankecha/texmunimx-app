import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/in_process_model.dart';
import 'package:texmunimx/models/order_status_enum.dart';
import 'package:texmunimx/models/purchase_order_list_response.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/utils/app_colors.dart';

class UpdateStatusBottomSheet extends StatefulWidget {
  final OrderStatus moveTo;
  final OrderStatus currentStatus;

  final PurchaseOrderModel po;

  const UpdateStatusBottomSheet({
    super.key,
    required this.po,
    required this.moveTo,
    required this.currentStatus,
  });

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _machineNoController = TextEditingController();
  final _remarksController = TextEditingController();

  FirmId? _selectedFirm;
  User? _selectedUser;

  PurchaseOrderController controller = Get.find();

  late PurchaseOrderModel po;

  int currentQty = 0;
  String currentLabel = 'pending'.tr;

  @override
  void dispose() {
    _quantityController.dispose();
    _machineNoController.dispose();
    _remarksController.dispose();

    super.dispose();
  }

  void currentPendingQuantity() {
    switch (widget.currentStatus) {
      case OrderStatus.pending:
        if (po.isJobPo) {
          currentQty = po.jobUser?.pending ?? 0;
        } else {
          currentQty = po.matching?.pending ?? 0;
        }
        currentLabel = 'pending'.tr;
        break;

      case OrderStatus.inProcess:
        currentQty = po.inProcess?.quantity ?? 0;
        currentLabel = 'in_process'.tr;
        break;

      case OrderStatus.readyToDispatch:
        currentQty = po.readyToDispatch?.quantity ?? 0;
        currentLabel = 'ready_to_dispatch'.tr;
        break;

      default:
        currentQty = po.jobUser?.pending ?? 0;
        break;
    }
  }

  // Function to handle the save action
  void _saveStatus() {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text);

      var body = {
        'id': po.id,
        'status': widget.moveTo.name,
        'quantity': quantity ?? 1,
        if (_machineNoController.text.isNotEmpty)
          'machineNo': _machineNoController.text.trim(),
        if (_remarksController.text.isNotEmpty)
          'remarks': _remarksController.text.trim(),
        if (po.isJobPo) ...{
          'jobUserId': widget.po.jobUser?.id,
        } else ...{
          'matchingObjId': po.matching?.id,
          'firmId': _selectedFirm?.id,
          'userId': _selectedUser?.id,
        },
        //inProcess
        if (widget.currentStatus == OrderStatus.inProcess) ...{
          'sourceId': widget.currentStatus == OrderStatus.inProcess
              ? widget.po.inProcess?.id
              : null,
          'matchingObjId': po.matching?.id,
          if (!po.isJobPo) 'firmId': po.inProcess?.firmId,
          if (!po.isJobPo) 'userId': po.inProcess?.userId,
        },
        //ready to dispatch
        if (widget.currentStatus == OrderStatus.readyToDispatch) ...{
          'sourceId': po.readyToDispatch?.id,
          'matchingObjId': po.matching?.id,
          if (!po.isJobPo) 'firmId': po.readyToDispatch?.firmId,
          if (!po.isJobPo) 'userId': po.readyToDispatch?.userId,
        },
      };

      log('update status body - $body');
      controller.updateStatusWithJobPo(
        id: po.id,
        status: widget.moveTo,
        current: widget.currentStatus,
        body: body,
      );
      // Close the bottom sheet
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    po = widget.po;
    currentPendingQuantity();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Title and Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'update_po_status'.tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Quantity headers
                Row(
                  children: [
                    Text(
                      'order_quantity'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      po.isJobPo
                          ? '${po.jobUser?.quantity ?? 0}'
                          : '${po.matching?.quantity ?? 0}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.currentStatus.name}'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '$currentQty',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.mainColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Move To field (pre-filled and not editable)
                _buildTitleRow(
                  'move_to'.trParams({
                    'status': widget.currentStatus.displayValue,
                  }),
                ),

                const SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                    color: const Color.fromARGB(255, 240, 240, 240),
                  ),
                  child: Row(children: [Text(widget.moveTo.displayValue)]),
                ),

                const SizedBox(height: 10),

                // Quantity field with validation
                _buildTitleRow('quantity'.tr),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter quantity (e.g. 99)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Quantity is required.';
                    }
                    final quantity = int.tryParse(value);
                    if (quantity == null || quantity <= 0) {
                      return 'Quantity must be greater than 0.';
                    }
                    if (quantity > currentQty) {
                      String type = widget.currentStatus.displayValue;
                      return 'quantity_cannot_exceed'.trParams({'type': type});
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Firm Name dropdown
                widget.moveTo == OrderStatus.inProcess && !po.isJobPo
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitleRow('firm_name'.tr),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<FirmId>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Select Firm'),
                            initialValue: _selectedFirm,
                            items: controller.firmList.map((firm) {
                              return DropdownMenuItem<FirmId>(
                                value: firm,
                                child: Text(firm.firmName),
                              );
                            }).toList(),
                            onChanged: (FirmId? newValue) {
                              setState(() {
                                _selectedFirm = newValue;
                              });
                            },
                            validator: (value) =>
                                value == null ? 'Please select a firm.' : null,
                          ),
                          const SizedBox(height: 20),
                          // User Name dropdown
                          Text(
                            'User Name',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<User>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Select User'),
                            initialValue: _selectedUser,
                            items: controller.userList.map((user) {
                              return DropdownMenuItem<User>(
                                value: user,
                                child: Text(user.fullname),
                              );
                            }).toList(),
                            onChanged: (User? newValue) {
                              setState(() {
                                _selectedUser = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      )
                    : SizedBox.shrink(),
                // Machine No field
                Text(
                  'machine_no'.tr,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _machineNoController,
                  decoration: const InputDecoration(
                    hintText: 'Enter machine no (e.g. M-01)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                // Remarks field
                Text('remarks'.tr, style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter remarks (e.g. Urgent order)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: AppColors.mainColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(String title) {
    return Row(
      children: [
        Text(
          // 'Move To * (Current Status: ${widget.currentStatus.displayValue})',
          title,
          style: TextStyle(color: Colors.grey[700]),
        ),
        SizedBox(width: 6),
        const RedMark(),
      ],
    );
  }
}
