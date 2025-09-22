import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/custom_btn_red.dart';
import 'package:textile_po/common_widgets/custom_progress_btn_.dart';
import 'package:textile_po/common_widgets/error_row.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/screens/create_design/widgets/delete_design_dialog.dart';
import 'package:textile_po/utils/app_colors.dart';

class CreateDesignScreen extends StatefulWidget {
  final DesignModel? designModel;
  const CreateDesignScreen({super.key, this.designModel});

  @override
  State<CreateDesignScreen> createState() => _CreateDesignScreenState();
}

class _CreateDesignScreenState extends State<CreateDesignScreen> {
  DesignModel? designModel;
  HomeController homeController = Get.find<HomeController>();
  CreateDesignController controller = Get.find<CreateDesignController>();

  //select image from phone
  selectImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      controller.setImage(image);
    }
  }

  @override
  void initState() {
    super.initState();
    designModel = widget.designModel;
    if (designModel != null) {
      controller.setDefaultFields(designModel!);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.resetInputs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: Colors.black26, width: 0.50),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Text(
                            'design_details'.tr,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Obx(
                            () => controller.err.value.isNotEmpty
                                ? ErrorRow(title: controller.err.value)
                                : SizedBox.shrink(),
                          ),
                          Row(
                            children: [
                              Text(
                                'design_name'.tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InputField(
                            hintText: 'enter_design_name'.tr,
                            textInputType: TextInputType.text,
                            textEditingController: controller.designNameCont,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'design_number'.tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          InputField(
                            hintText: 'enter_design_number'.tr,
                            textInputType: TextInputType.text,
                            textEditingController: controller.designNumberCont,
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'design_image'.tr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              dashPattern: [6, 4],
                              strokeWidth: 1,
                              radius: Radius.circular(6),
                            ),
                            child: InkWell(
                              onTap: () => selectImage(),
                              child: Obx(
                                () => controller.selectedDesignImage.isNotEmpty
                                    ? Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 140,
                                              child: Image.network(
                                                controller.imageBasePath +
                                                    controller
                                                        .selectedDesignImage
                                                        .value,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox(
                                        child:
                                            controller.selectedImage.value !=
                                                null
                                            ? Row(
                                                children: [
                                                  Expanded(
                                                    child: SizedBox(
                                                      height: 140,
                                                      child: Image.file(
                                                        File(
                                                          controller
                                                                  .selectedImage
                                                                  .value
                                                                  ?.path ??
                                                              '',
                                                        ),
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                height: 140,
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .add_photo_alternate,
                                                        size: 76,
                                                        color: Colors.grey,
                                                      ),
                                                      Text(
                                                        'tap_to_upload_photo'
                                                            .tr,
                                                        style: TextStyle(
                                                          fontSize: 14,

                                                          color: AppColors
                                                              .blackColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                      ),
                              ),
                            ),
                          ),
                          Obx(
                            () =>
                                controller
                                        .selectedDesignImage
                                        .value
                                        .isNotEmpty ||
                                    controller.selectedImage.value != null
                                ? TextButton(
                                    onPressed: () {
                                      controller.selectedDesignImage.value = '';
                                      controller.selectedImage.value = null;
                                    },
                                    child: Text('Remove Image'),
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () => controller.isLoading.value
                          ? CustomProgressBtn()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: CustomBtn(
                                title: designModel != null
                                    ? 'update_design'.tr
                                    : 'submit_design'.tr,
                                onTap: () {
                                  if (designModel != null) {
                                    controller.updateDesign();
                                  } else {
                                    controller.onCreatePo();
                                  }
                                },
                              ),
                            ),
                    ),
                    SizedBox(height: 12),

                    if (designModel != null)
                      CustomBtnRed(
                        title: 'Delete',
                        onTap: () {
                          Get.dialog(DeleteDesignDialog());
                        },
                        isOutline: true,
                      ),

                    SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
