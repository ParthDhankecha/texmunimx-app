import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/custom_btn_red.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/firm_controller.dart';
import 'package:textile_po/models/firm_list_response.dart';

class CreateFirmScreen extends StatefulWidget {
  final FirmModel? firm;
  const CreateFirmScreen({super.key, this.firm});

  @override
  State<CreateFirmScreen> createState() => _CreateFirmScreenState();
}

class _CreateFirmScreenState extends State<CreateFirmScreen> {
  TextEditingController nameController = TextEditingController();

  FirmController firmController = Get.find<FirmController>();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  void setUserData() {
    if (widget.firm != null) {
      nameController.text = widget.firm!.firmName;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.firm != null ? 'edit_firm'.tr : 'add_firm'.tr),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                        label: 'firm_name'.tr,
                        hintText: 'firm_enter_name'.tr,
                        keyboardType: TextInputType.name,
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'firm_name_required'.tr;
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 10),
                      Obx(
                        () => firmController.isLoading.value
                            ? Center(child: CircularProgressIndicator())
                            : Column(
                                children: [
                                  CustomBtn(
                                    title: widget.firm != null
                                        ? 'update'.tr
                                        : 'create'.tr,
                                    onTap: () {
                                      if (formKey.currentState!.validate()) {
                                        // All fields are valid, proceed with user creation
                                        // You can access the input values using the controllers
                                        String name = nameController.text
                                            .trim();

                                        if (widget.firm != null) {
                                          firmController.updateFirm(
                                            firmId: widget.firm!.id.toString(),
                                            name: name,
                                          );
                                        } else {
                                          firmController.createFirm(name: name);
                                        }
                                      }
                                    },
                                  ),

                                  if (widget.firm != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 12),
                                      child: CustomBtnRed(
                                        title: 'delete'.tr,

                                        onTap: () {
                                          // Handle delete user logic here
                                          Get.defaultDialog(
                                            title: 'confirm'.tr,
                                            middleText:
                                                'are_you_sure_you_want_to_delete_firm'
                                                    .tr,
                                            //textCancel: 'no'.tr,
                                            textConfirm: 'delete'.tr,
                                            confirmTextColor: Colors.white,
                                            buttonColor: Colors.red,
                                            cancel: TextButton(
                                              onPressed: () => Get.back(),
                                              child: Text('no'.tr),
                                            ),
                                            onConfirm: () {
                                              Get.back();
                                              firmController.deleteFirm(
                                                firmId: widget.firm!.id
                                                    .toString(),
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              ' *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        InputField(
          textEditingController: controller,
          hintText: hintText,
          onValidator: validator,
          textInputType: keyboardType,
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
