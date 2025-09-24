import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/models/in_process_model.dart';
import 'package:textile_po/models/order_status_enum.dart';

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

  const UpdateStatusBottomSheet({
    super.key,
    required this.orderQuantity,
    required this.pendingQuantity,
    required this.moveTo,
    required this.currentStatus,
    required this.purchaseId,
    this.quantityTitle = 'Pending',
    required this.firmId,
    required this.userId,
    this.machineNo,
  });

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  // Controllers and state for form management
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _machineNoController = TextEditingController();
  final _remarksController = TextEditingController();

  FirmId? _selectedFirm;
  MovedBy? _selectedUser;

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
      // Form is valid, perform the action
      final quantity = int.tryParse(_quantityController.text);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processing Data')));

      controller.updateOrderStatus(
        id: widget.purchaseId,
        status: widget.moveTo,
        current: widget.currentStatus,
        quantity: quantity ?? 1,
        fId: widget.currentStatus == OrderStatus.pending
            ? _selectedFirm?.id
            : widget.firmId,
        uId: widget.currentStatus == OrderStatus.pending
            ? _selectedUser?.id
            : widget.userId,
        machineNo: _machineNoController.text.isEmpty
            ? null
            : _machineNoController.text.trim(),
        remarks: _remarksController.text.isEmpty
            ? null
            : _remarksController.text.trim(),
      );
      // Close the bottom sheet
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _machineNoController.text = widget.machineNo ?? '';
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
                    const Text(
                      'Update Purchase Order Status',
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
                const SizedBox(height: 20),

                // Quantity headers
                Row(
                  children: [
                    Text(
                      'Order Quantity: ${widget.orderQuantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.quantityTitle} Quantity: ${widget.pendingQuantity}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Move To field (pre-filled and not editable)
                Text(
                  'Move To * (Current Status: ${widget.currentStatus.displayValue})',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: widget.moveTo.displayValue,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'In Process',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Color.fromARGB(255, 240, 240, 240),
                  ),
                ),
                const SizedBox(height: 20),

                // Quantity field with validation
                Text('Quantity *', style: TextStyle(color: Colors.grey[700])),
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
                      return 'Quantity cannot exceed pending quantity.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Firm Name dropdown
                widget.moveTo == OrderStatus.inProcess
                    ? Column(
                        children: [
                          Text(
                            'Firm Name *',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
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
                          DropdownButtonFormField<MovedBy>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Select User'),
                            initialValue: _selectedUser,
                            items: controller.userList.map((user) {
                              return DropdownMenuItem<MovedBy>(
                                value: user,
                                child: Text(user.fullname),
                              );
                            }).toList(),
                            onChanged: (MovedBy? newValue) {
                              setState(() {
                                _selectedUser = newValue;
                              });
                            },
                          ),
                          const SizedBox(height: 20),

                          // Machine No field
                          Text(
                            'Machine No',
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
                          const SizedBox(height: 20),
                        ],
                      )
                    : SizedBox.shrink(),

                // Remarks field
                Text('Remarks', style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _remarksController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Enter remarks (e.g. Urgent order)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.blue),
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
                          backgroundColor: Colors.blue,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
