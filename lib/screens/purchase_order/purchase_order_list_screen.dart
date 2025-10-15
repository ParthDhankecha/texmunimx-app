import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/widgets/delivered_card.dart';
import 'package:texmunimx/screens/purchase_order/widgets/in_process_card.dart';
import 'package:texmunimx/screens/purchase_order/widgets/purchase_order_card.dart';
import 'package:texmunimx/screens/purchase_order/widgets/ready_to_dispatch_card.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/shared_pref.dart';

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage>
    with TickerProviderStateMixin {
  final PurchaseOrderController controller = Get.find();
  final Sharedprefs sp = Get.find<Sharedprefs>();
  late final TabController tabController;

  @override
  void initState() {
    super.initState();
    controller.getPurchaseList();
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    tabController.addListener(onTabChanging);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        title: Text('purchase_order'.tr),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: AppColors.mainColor,
          labelColor: AppColors.mainColor,
          unselectedLabelColor: Colors.black,

          tabs: [
            Tab(text: 'pending'.tr),
            Tab(text: 'in_progress'.tr),
            Tab(text: 'ready_to_dispatch'.tr),
            Tab(text: 'completed'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          //pending
          Obx(
            () => ListView.builder(
              itemCount: controller.purchaseOrdersList.length,
              itemBuilder: (context, index) {
                final order = controller.purchaseOrdersList[index];

                final design = controller.designList.firstWhere(
                  (d) => d.id == order.designId,
                  orElse: () => Design(
                    id: '',
                    designName: 'Unknown Design',
                    designImage: '',
                    designNumber: '',
                  ),
                );

                final party = controller.partyList.firstWhere(
                  (p) => p.id == order.partyId,
                  orElse: () => Party(
                    id: '',
                    partyName: 'Unknown Party',

                    partyNumber: '',
                    mobile: '',
                  ),
                );
                return PurchaseOrderCard(
                  order: order,
                  design: design,
                  party: party,
                  isEditvisible:
                      sp.userRole == sp.admin || sp.userRole == sp.owner,
                );
              },
            ),
          ),

          //In Process
          Obx(
            () => ListView.builder(
              itemCount: controller.inProcessList.length,
              itemBuilder: (context, index) {
                final order = controller.inProcessList[index];

                final design = controller.designList.firstWhere(
                  (d) => d.id == order.designId,
                  orElse: () => Design(
                    id: '',
                    designName: 'Unknown Design',
                    designImage: '',
                    designNumber: '',
                  ),
                );

                final party = controller.partyList.firstWhere(
                  (p) => p.id == order.partyId,
                  orElse: () => Party(
                    id: '',
                    partyName: 'Unknown Party',

                    partyNumber: '',
                    mobile: '',
                  ),
                );
                return InProcessCard(
                  order: controller.inProcessList[index],
                  design: design,
                  party: party,
                );
              },
            ),
          ),

          //Ready to dispatch
          Obx(
            () => controller.readyToDispatchList.isEmpty
                ? Center(child: Text('No records found!'))
                : ListView.builder(
                    itemCount: controller.readyToDispatchList.length,
                    itemBuilder: (context, index) {
                      final order = controller.readyToDispatchList[index];

                      final design = controller.designList.firstWhere(
                        (d) => d.id == order.designId,
                        orElse: () => Design(
                          id: '',
                          designName: 'Unknown Design',
                          designImage: '',
                          designNumber: '',
                        ),
                      );

                      final party = controller.partyList.firstWhere(
                        (p) => p.id == order.partyId,
                        orElse: () => Party(
                          id: '',
                          partyName: 'Unknown Party',

                          partyNumber: '',
                          mobile: '',
                        ),
                      );

                      return ReadyToDispatchCard(
                        order: order,
                        design: design,
                        party: party,
                      );
                    },
                  ),
          ),

          //Completed
          Obx(
            () => controller.deliveredList.isEmpty
                ? Center(child: Text('No records found!'))
                : ListView.builder(
                    itemCount: controller.deliveredList.length,
                    itemBuilder: (context, index) {
                      final order = controller.deliveredList[index];

                      final design = controller.designList.firstWhere(
                        (d) => d.id == order.designId,
                        orElse: () => Design(
                          id: '',
                          designName: 'Unknown Design',
                          designImage: '',
                          designNumber: '',
                        ),
                      );

                      final party = controller.partyList.firstWhere(
                        (p) => p.id == order.partyId,
                        orElse: () => Party(
                          id: '',
                          partyName: 'Unknown Party',

                          partyNumber: '',
                          mobile: '',
                        ),
                      );
                      return DeliveredCard(
                        order: controller.deliveredList[index],
                        design: design,
                        party: party,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void onTabChanging() {
    if (!tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          controller.getPurchaseList(status: 'pending', isRefresh: true);

          break;
        case 1:
          controller.getInProcessList(status: 'inProcess', isRefresh: true);

          break;
        case 2:
          controller.getInProcessList(
            status: 'readyToDispatch',
            isRefresh: true,
          );
          break;
        default:
          controller.getInProcessList(status: 'delivered', isRefresh: true);
      }
    }
  }
}
