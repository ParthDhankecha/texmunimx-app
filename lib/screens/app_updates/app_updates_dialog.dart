import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/controllers/app_update_controller.dart';
import 'package:texmunimx/utils/app_colors.dart';

class AppUpdatesDialog extends StatefulWidget {
  const AppUpdatesDialog({super.key});

  @override
  State<AppUpdatesDialog> createState() => _AppUpdatesDialogState();
}

class _AppUpdatesDialogState extends State<AppUpdatesDialog> {
  AppUpdateController appUpdateController = Get.find<AppUpdateController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('app_update'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('new_version_available'.tr),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${'current_version'.tr}: '),
              Text(
                appUpdateController.currentAppVersion.value,
                style: bodyStyle1,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${'latest_version'.tr}: '),
              Text(
                appUpdateController.latestAppVersion.value,
                style: bodyStyle1,
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (!appUpdateController.forceUpdate.value)
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancel'.tr),
          ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainColor),
          child: Text(
            'update_now'.tr,
            style: bodyStyle1.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
