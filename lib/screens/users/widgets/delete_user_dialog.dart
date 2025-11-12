import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/controllers/user_controller.dart';

class DeleteUserDialog extends StatelessWidget {
  final String userId;
  const DeleteUserDialog({super.key, required this.userId});

  UserController get userController => Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('confirm'.tr),
      content: Text('are_you_sure_you_want_to_delete_user'.tr),
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
            title: 'delete'.tr,
            onTap: () {
              Get.back();
              Get.find<UserController>().deleteUser(userId: userId);
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
