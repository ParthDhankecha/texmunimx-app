import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/controllers/create_design_controller.dart';

class DeleteDesignDialog extends StatelessWidget {
  const DeleteDesignDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Design'.tr),
      content: Text('Are you sure you want to Delete this design?'.tr),
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
              Get.find<CreateDesignController>().deleteDesign();
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
