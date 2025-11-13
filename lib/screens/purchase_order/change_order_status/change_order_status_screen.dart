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
  final int orderQuantity;
  final int pendingQuantity;
  final OrderStatus currentStatus;
  final OrderStatus moveTo;
  final String purchaseId;
  final String firmId;
  final String userId;
  final String? quantityTitle;
  final String? machineNo;
  final String? machinObjId;
  final bool isJobPo;

  final PurchaseOrderModel po;

  const UpdateStatusBottomSheet({
    super.key,
    required this.po,
    required this.orderQuantity,
    required this.pendingQuantity,
    required this.moveTo,
    required this.currentStatus,
    required this.purchaseId,
    this.quantityTitle = 'Pending',
    required this.firmId,
    required this.userId,
    this.machineNo,
    this.machinObjId,
    this.isJobPo = true,
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

  @override
  void dispose() {
    _quantityController.dispose();
    _machineNoController.dispose();
    _remarksController.dispose();

    super.dispose();
  }

  // Function to handle the save action
  void _saveStatus() {
    if (_formKey.currentState!.validate()) {
      final quantity = int.tryParse(_quantityController.text);

      var body = {
        'id': widget.purchaseId,
        'status': widget.moveTo.name,
        'quantity': quantity ?? 1,
        if (_machineNoController.text.isNotEmpty)
          'machineNo': _machineNoController.text.trim(),
        if (_remarksController.text.isNotEmpty)
          'remarks': _remarksController.text.trim(),
        if (widget.isJobPo) ...{
          if (widget.machinObjId != null) 'jobUserId': widget.po.jobUser?.id,
        } else ...{
          'matchingObjId': widget.po.matching?.id,
          'firmId': _selectedFirm?.id,
          'userId': _selectedUser?.id,
        },
        //inProcess
        if (widget.currentStatus == OrderStatus.inProcess) ...{
          'sourceId': widget.currentStatus == OrderStatus.inProcess
              ? widget.po.inProcess?.id
              : null,
          'matchingObjId': widget.po.matching?.id,
          if (!widget.isJobPo) 'firmId': widget.po.inProcess?.firmId,
          if (!widget.isJobPo) 'userId': widget.po.inProcess?.userId,
        },
        //ready to dispatch
        if (widget.currentStatus == OrderStatus.readyToDispatch) ...{
          'sourceId': widget.po.readyToDispatch?.id,
          'matchingObjId': widget.po.matching?.id,
          if (!widget.isJobPo) 'firmId': widget.po.readyToDispatch?.firmId,
          if (!widget.isJobPo) 'userId': widget.po.readyToDispatch?.userId,
        },
      };

      log('update status body - $body');
      controller.updateStatusWithJobPo(
        id: widget.purchaseId,
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
                      '${widget.po.matching?.quantity ?? widget.orderQuantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '${widget.quantityTitle}'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.pendingQuantity}',
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
                    if (quantity > widget.pendingQuantity) {
                      String type = widget.quantityTitle ?? 'Pending';
                      return 'quantity_cannot_exceed'.trParams({'type': type});
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),

                // Firm Name dropdown
                widget.moveTo == OrderStatus.inProcess && !widget.isJobPo
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
