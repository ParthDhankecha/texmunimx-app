import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/home_controller.dart';
import 'package:textile_po/utils/app_colors.dart';

class CreatePoScreen extends StatefulWidget {
  const CreatePoScreen({super.key});

  @override
  State<CreatePoScreen> createState() => _CreatePoScreenState();
}

class _CreatePoScreenState extends State<CreatePoScreen> {
  HomeController homeController = Get.find<HomeController>();

  //select image from phone
  selectImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      homeController.setImage(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                          'Design Details',
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
                        Row(
                          children: [
                            Text(
                              'Design Name',
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
                          hintText: 'Enter Design Name',
                          textInputType: TextInputType.text,
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
                              'Design Number',
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
                          hintText: 'Enter Design Number (EX. WF-100)',
                          textInputType: TextInputType.text,
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
                              'Design Image',
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
                              () => homeController.selectedImage.value != null
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 140,
                                            child: Image.file(
                                              File(
                                                homeController
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
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_photo_alternate,
                                              size: 76,
                                            ),
                                            Text(
                                              'Tap to Upload a photo',
                                              style: TextStyle(
                                                fontSize: 14,

                                                color: AppColors.blackColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomBtn(title: 'Submit Design', onTap: () {}),

                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
