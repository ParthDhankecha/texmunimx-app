import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/controllers/firm_controller.dart';
import 'package:texmunimx/screens/firms/create_firm_screen.dart';
import 'package:texmunimx/utils/app_colors.dart';

class FirmListScreen extends StatefulWidget {
  const FirmListScreen({super.key});

  @override
  State<FirmListScreen> createState() => _FirmListScreenState();
}

class _FirmListScreenState extends State<FirmListScreen> {
  FirmController firmController = Get.find<FirmController>();

  @override
  void initState() {
    super.initState();
    firmController.fetchFirms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('firms'.tr)),
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
            if (firmController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (firmController.firms.isEmpty) {
              return Center(child: Text('no_firms_found'.tr));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: firmController.firms.length,
                  itemBuilder: (context, index) {
                    final firm = firmController.firms[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.mainColor,
                          child: Text(
                            firm.firmName.isNotEmpty
                                ? firm.firmName[0].toUpperCase()
                                : '?',
                          ),
                        ),
                        title: Text(firm.firmName),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: AppColors.mainColor,
                              ),
                              onPressed: () {
                                // Handle edit action
                                Get.to(() => CreateFirmScreen(firm: firm));
                              },
                            ),
                          ],
                        ),
                      ),
                    );
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
