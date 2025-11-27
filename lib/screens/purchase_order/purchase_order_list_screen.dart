import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/screens/purchase_order/order_list_cards/delivered_card.dart';
import 'package:texmunimx/screens/purchase_order/order_list_cards/in_process_card.dart';
import 'package:texmunimx/screens/purchase_order/order_list_cards/purchase_order_card.dart';
import 'package:texmunimx/screens/purchase_order/order_list_cards/ready_to_dispatch_card.dart';
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
    controller.fetchOptionsData();
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
    final isSelected = selected == index;

    return GestureDetector(
      onTap: () {
        tabController.animateTo(index);
        selectedIndex.value = index;
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
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

            child: Container(
              color:
                  Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,

                child: Row(
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
                  () => controller.purchaseListLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : controller.purchaseOrdersList.isEmpty
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

                            final jobUser = controller.jobUserNameById(
                              order.jobUser?.userId ?? '',
                            );

                            return PurchaseOrderCard(
                              order: order,
                              design: design,
                              party: party,
                              jobUser: jobUser,
                              isEditvisible:
                                  sp.userRole == sp.admin ||
                                  sp.userRole == sp.owner,
                            );
                          },
                        ),
                ),

                //In Process
                Obx(
                  () => controller.inProcessListLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : controller.inProcessList.isEmpty
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

                            final jobUser = controller.jobUserNameById(
                              order.jobUser?.userId ?? '',
                            );

                            return InProcessCard(
                              order: controller.inProcessList[index],
                              design: design,
                              party: party,
                              jobUser: jobUser,
                            );
                          },
                        ),
                ),

                //Ready to dispatch
                Obx(
                  () => controller.readyToDispatchListLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : controller.readyToDispatchList.isEmpty
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

                            final jobUser = controller.jobUserNameById(
                              order.jobUser?.userId ?? '',
                            );

                            return ReadyToDispatchCard(
                              order: order,
                              design: design,
                              party: party,
                              jobUser: jobUser,
                            );
                          },
                        ),
                ),

                //Completed
                Obx(
                  () => controller.deliveredListLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : controller.deliveredList.isEmpty
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

                            final jobUser = controller.jobUserNameById(
                              order.jobUser?.userId ?? '',
                            );
                            return DeliveredCard(
                              order: controller.deliveredList[index],
                              design: design,
                              party: party,
                              jobUser: jobUser,
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
