import 'package:flutter/material.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:textile_po/screens/create_design/design_list_screen.dart';
import 'package:textile_po/screens/purchase_order/create_purchase_order.dart';
import 'package:textile_po/screens/purchase_order/purchase_order_list_screen.dart';
import 'package:textile_po/screens/settings/settings_screen.dart';
import 'package:textile_po/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.find();

  List<Widget> widgetList = [
    Text('Home'),
    PurchaseOrderListPage(),
    CreatePurchaseOrder(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => widgetList.elementAt(homeController.selectedIndex.value)),
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
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.list_outlined),
              label: 'PO List',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'Create PO',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
