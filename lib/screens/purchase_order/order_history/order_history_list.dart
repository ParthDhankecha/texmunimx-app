import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/firm_controller.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/models/order_history_response.dart';
import 'package:textile_po/screens/firms/create_firm_screen.dart';
import 'package:textile_po/screens/purchase_order/order_history/widget/order_history_card.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/date_formate_extension.dart';

class OrderHistoryListScreen extends StatefulWidget {
  const OrderHistoryListScreen({super.key, this.id});

  final String? id;

  @override
  State<OrderHistoryListScreen> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen> {
  PurchaseOrderController purchaseOrderController =
      Get.find<PurchaseOrderController>();

  @override
  void initState() {
    super.initState();
    purchaseOrderController.fatchOrderHistoryById(widget.id ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('history'.tr)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.mainColor,
        onPressed: () {
          // Navigate to add firm screen
          Get.to(() => CreateFirmScreen());
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Divider(color: Colors.grey.shade500, thickness: 1),
          Obx(() {
            if (purchaseOrderController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (purchaseOrderController.orderHistoryList.isEmpty) {
              return Center(child: Text('no_order_history_found'.tr));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: purchaseOrderController.orderHistoryList.length,
                  itemBuilder: (context, index) {
                    final order =
                        purchaseOrderController.orderHistoryList[index];
                    return OrderHistoryCard(order: order);
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
