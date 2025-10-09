import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/controllers/login_controllers.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('logout'.tr),
      content: Text('confirm_logout'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            Get.find<LoginControllers>().logout();
            Get.find<HomeController>().selectedIndex.value = 0;
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            'logout'.tr,
            style: bodyStyle1.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
