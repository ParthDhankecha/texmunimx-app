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

  RxInt selectedIndex = 0.obs;

  @override
  void initState() {
    super.initState();
    controller.getPurchaseList(isRefresh: true);
    tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    tabController.addListener(onTabChanging);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  Widget _buildCustomTab({
    required String title,
    required int index,
    required int selected,
  }) {
    // Check if this tab is currently selected
    final isSelected = selected == index;

    return GestureDetector(
      onTap: () {
        // Switch the TabBarView to the correct index
        tabController.animateTo(index);
        selectedIndex.value = index;
        // setState is called in onTabChanging, so it will update the UI
      },
      child: Container(
        alignment: Alignment.center,
        // Set your custom padding here. Horizontal: 16.0 provides breathing room.
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  // Use a bottom border as the indicator
                  bottom: BorderSide(color: AppColors.mainColor, width: 2.0),
                )
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.mainColor : Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 6, title: Text('purchase_order'.tr)),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(40),
            // child: TabBar(
            //   controller: tabController,
            //   indicatorColor: AppColors.mainColor,
            //   labelColor: AppColors.mainColor,
            //   unselectedLabelColor: Colors.black,
            //   isScrollable: true,
            //   labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            //   padding: EdgeInsets.zero,

            //   tabs: [
            //     Tab(text: 'pending'.tr, iconMargin: EdgeInsets.only(right: 0)),
            //     Tab(
            //       text: 'in_progress'.tr,
            //       iconMargin: EdgeInsets.only(right: 0),
            //     ),
            //     Tab(
            //       text: 'ready_to_dispatch'.tr,
            //       iconMargin: EdgeInsets.only(right: 0),
            //     ),
            //     Tab(
            //       text: 'completed'.tr,
            //       iconMargin: EdgeInsets.only(right: 0),
            //     ),
            //   ],
            // ),
            child: Container(
              color:
                  Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
              // Use SingleChildScrollView to allow for scrollable tabs
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                // Use a Row to lay out the custom tabs horizontally
                child: Row(
                  // Crucially set this to start, forcing tabs to the left edge
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                      [
                            'pending'.tr,
                            'in_progress'.tr,
                            'ready_to_dispatch'.tr,
                            'completed'.tr,
                          ]
                          .asMap()
                          .entries
                          .map(
                            (entry) => Obx(
                              () => _buildCustomTab(
                                title: entry.value,
                                index: entry.key,
                                selected: selectedIndex.value,
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                //pending
                Obx(
                  () => controller.purchaseOrdersList.isEmpty
                      ? Center(child: Text('No records found!'))
                      : ListView.builder(
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
                                  sp.userRole == sp.admin ||
                                  sp.userRole == sp.owner,
                            );
                          },
                        ),
                ),

                //In Process
                Obx(
                  () => controller.inProcessList.isEmpty
                      ? Center(child: Text('No records found!'))
                      : ListView.builder(
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
          selectedIndex.value = 0;

          break;
        case 1:
          controller.getInProcessList(status: 'inProcess', isRefresh: true);
          selectedIndex.value = 1;

          break;
        case 2:
          controller.getInProcessList(
            status: 'readyToDispatch',
            isRefresh: true,
          );
          selectedIndex.value = 2;
          break;
        default:
          controller.getInProcessList(status: 'delivered', isRefresh: true);
          selectedIndex.value = 3;
      }
    }
  }
}
