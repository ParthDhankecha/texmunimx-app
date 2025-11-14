import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/address_input_field.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/common_widgets/custom_btn_red.dart';
import 'package:texmunimx/common_widgets/custom_progress_btn_.dart';
import 'package:texmunimx/common_widgets/error_row.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/controllers/party_controller.dart';
import 'package:texmunimx/models/party_list_response.dart';
import 'package:texmunimx/screens/party/widgets/delete_party_dialog.dart';
import 'package:texmunimx/utils/app_colors.dart';

class CreatePartyScreen extends StatefulWidget {
  final PartyModel? partyModel;
  const CreatePartyScreen({super.key, this.partyModel});

  @override
  State<CreatePartyScreen> createState() => _CreatePartyScreenState();
}

class _CreatePartyScreenState extends State<CreatePartyScreen> {
  PartyModel? partyModel;
  PartyController controller = Get.find<PartyController>();

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller.err.value = '';
    partyModel = widget.partyModel;
    if (partyModel != null) {
      controller.setDefaultFields(partyModel!);
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
        title: Text(partyModel != null ? 'update_party'.tr : 'create_party'.tr),
        // leading: IconButton(
        //   onPressed: () {
        //     Get.back();
        //   },
        //   icon: Icon(Icons.arrow_back_ios),
        // ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
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
                                  'party_name'.tr,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.blackColor,
                                  ),
                                ),
                                _mark(),
                              ],
                            ),
                            SizedBox(height: 10),
                            InputField(
                              hintText: 'enter_party_name'.tr,
                              textInputType: TextInputType.text,
                              textEditingController: controller.partyNameCont,
                            ),
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'customer_name'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                InputField(
                                  hintText: 'enter_customer_name'.tr,
                                  textInputType: TextInputType.text,
                                  textEditingController:
                                      controller.partyNumberCont,
                                ),
                              ],
                            ),

                            //gst
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'gst_number'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                InputField(
                                  hintText: 'enter_gst_number'.tr,
                                  textInputType: TextInputType.text,
                                  textEditingController: controller.gstCont,
                                ),
                              ],
                            ),

                            //phone
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'phone_number'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                InputField(
                                  hintText: 'enter_phone_number'.tr,
                                  textInputType: TextInputType.phone,
                                  textEditingController:
                                      controller.phoneNumberCont,
                                ),
                              ],
                            ),

                            //email
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'email'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                InputField(
                                  hintText: 'enter_email_address'.tr,
                                  textInputType: TextInputType.emailAddress,
                                  textEditingController: controller.emailCont,
                                ),
                              ],
                            ),

                            //address
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'address'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                AddressInputField(
                                  hintText: 'enter_full_address'.tr,
                                  textInputType: TextInputType.text,
                                  textEditingController: controller.addressCont,
                                ),
                              ],
                            ),

                            //address
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'brokers_name'.tr,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                InputField(
                                  hintText: 'Enter Broker Name',
                                  textInputType: TextInputType.text,
                                  textEditingController: controller.brokerCont,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Obx(
                        () => controller.isLoading.value
                            ? CustomProgressBtn()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomBtn(
                                  title: partyModel != null
                                      ? 'update_party'.tr
                                      : 'submit_party'.tr,
                                  onTap: () {
                                    controller.err.value = '';
                                    if (controller.checkValidation()) {
                                      if (partyModel != null) {
                                        controller.updateParty();
                                      } else {
                                        controller.createNewParty();
                                      }
                                    }
                                  },
                                ),
                              ),
                      ),

                      if (partyModel != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 8.0,
                          ),
                          child: CustomBtnRed(
                            title: 'delete'.tr,
                            onTap: () {
                              Get.dialog(DeletePartyDialog());
                            },
                            isOutline: true,
                          ),
                        ),

                      SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text _mark() {
    return Text(
      ' * ',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.errorColor,
      ),
    );
  }
}
