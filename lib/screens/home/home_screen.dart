import 'package:flutter/material.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:textile_po/screens/purchase_order/create_po/create_purchase_order.dart';
import 'package:textile_po/screens/purchase_order/purchase_order_list_screen.dart';
import 'package:textile_po/screens/settings/settings_screen.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/shared_pref.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();

  Sharedprefs sp = Get.find<Sharedprefs>();

  List<Widget> widgetList = [
    const Center(child: Text('Home Screen')),
    const PurchaseOrderListPage(),
    const SettingsScreen(),
  ];
  List<Widget> adminWidgetList = [
    const Center(child: Text('Home Screen')),
    const PurchaseOrderListPage(),
    const CreatePurchaseOrder(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    homeController.selectedIndex.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => sp.userRole == sp.owner || sp.userRole == sp.admin
            ? adminWidgetList.elementAt(homeController.selectedIndex.value)
            : widgetList.elementAt(homeController.selectedIndex.value),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: AppColors.mainColor,

          type: BottomNavigationBarType.fixed,
          currentIndex: homeController.selectedIndex.value,
          onTap: (value) {
            homeController.changeIndex(value);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'home'.tr,
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'po_list'.tr,
            ),
            if (sp.userRole == sp.owner || sp.userRole == sp.admin)
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle_outline),
                label: 'create_po'.tr,
              ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
