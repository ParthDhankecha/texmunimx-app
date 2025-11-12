import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/controllers/create_design_controller.dart';

class DeleteJobOrMatchingDialog extends StatelessWidget {
  final bool isJob;
  final Function()? onDelete;
  const DeleteJobOrMatchingDialog({
    super.key,
    required this.isJob,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isJob ? 'Delete Job'.tr : 'Delete Matching'.tr),
      content: Text(
        isJob
            ? 'Are you sure you want to Delete this job?'.tr
            : 'Are you sure you want to Delete this matching?'.tr,
      ),
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
              Get.back();
              onDelete?.call();
            },
          ),
        ),
      ],
    );
  }
}
