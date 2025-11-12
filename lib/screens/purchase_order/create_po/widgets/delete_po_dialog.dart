import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';

class DeletePODialog extends StatelessWidget {
  const DeletePODialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete PO'.tr),
      content: Text('Are you sure you want to Delete this PO?'.tr),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'.tr),
        ),
        SizedBox(
          width: 100,
          child: CustomBtnRed(
            title: 'Delete',
            onTap: () {
              Get.back(result: 'delete');
            },
          ),
        ),
      ],
    );
  }
}
