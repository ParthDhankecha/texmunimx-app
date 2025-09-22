import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/screens/purchase_order/widgets/purchase_order_card.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage>
    with SingleTickerProviderStateMixin {
  final PurchaseOrderController controller = Get.find();
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    controller.getPurchaseList();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(onTabChanging);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Purchase Orders'),
          bottom: TabBar(
            controller: tabController,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'In Process'),
              Tab(text: 'Ready to Dispatch'),
              Tab(text: 'Completed'),
            ],
            onTap: (value) {
              print('myTab = $value');
            },
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Obx(
              () => ListView.builder(
                itemCount: controller.purchaseOrdersList.length,
                itemBuilder: (context, index) {
                  return PurchaseOrderCard(
                    order: controller.purchaseOrdersList[index],
                  );
                },
              ),
            ),
            Obx(
              () => ListView.builder(
                itemCount: controller.purchaseOrdersList.length,
                itemBuilder: (context, index) {
                  return PurchaseOrderCard(
                    order: controller.purchaseOrdersList[index],
                  );
                },
              ),
            ),
            Obx(
              () => ListView.builder(
                itemCount: controller.purchaseOrdersList.length,
                itemBuilder: (context, index) {
                  return PurchaseOrderCard(
                    order: controller.purchaseOrdersList[index],
                  );
                },
              ),
            ),
            Obx(
              () => ListView.builder(
                itemCount: controller.purchaseOrdersList.length,
                itemBuilder: (context, index) {
                  return PurchaseOrderCard(
                    order: controller.purchaseOrdersList[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onTabChanging() {
    if (tabController.indexIsChanging) {
      print('i am changing');
      switch (tabController.index) {
        case 0:
          controller.getPurchaseList(status: 'pending', isRefresh: true);

          break;
        case 1:
          controller.getPurchaseList(status: 'inProcess', isRefresh: true);

          break;
        default:
          controller.getPurchaseList(status: 'pending', isRefresh: true);
      }
    }
  }
}
