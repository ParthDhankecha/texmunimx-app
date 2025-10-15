import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/controllers/party_controller.dart';

class DeletePartyDialog extends StatelessWidget {
  const DeletePartyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Party'.tr),
      content: Text('Are you sure you want to Delete this Party?'.tr),
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
              Get.find<PartyController>().deleteParty();
            },
          ),
        ),
      ],
    );
  }
}
