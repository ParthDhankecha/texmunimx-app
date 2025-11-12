import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';

class FirmDeleteDialog extends StatelessWidget {
  const FirmDeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('confirm'.tr),
      content: Text('are_you_sure_you_want_to_delete_firm'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(result: 'delete');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            'delete'.tr,
            style: bodyStyle1.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
