import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';

class ExitDialog extends StatelessWidget {
  const ExitDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('exit'.tr),
      content: Text('are_you_sure_you_want_to_exit_app'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('cancel'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back(result: 'exit');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: Text(
            'exit'.tr,
            style: bodyStyle1.copyWith(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
