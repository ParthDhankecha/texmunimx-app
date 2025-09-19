import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/address_input_field.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/common_widgets/custom_btn_red.dart';
import 'package:textile_po/common_widgets/custom_progress_btn_.dart';
import 'package:textile_po/common_widgets/error_row.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/controllers/party_controller.dart';
import 'package:textile_po/models/party_list_response.dart';
import 'package:textile_po/screens/party/widgets/delete_party_dialog.dart';
import 'package:textile_po/utils/app_colors.dart';

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
        title: Text(partyModel != null ? 'Update Party' : 'Create Party'),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
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
                                  'Party Name ',
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
                              hintText: 'Enter Party Name',
                              textInputType: TextInputType.text,
                              textEditingController: controller.partyNameCont,
                              onValidator: (value) {
                                if (value!.isEmpty) {
                                  controller.err.value =
                                      'Party Name is Mandatory';
                                  return '';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 14),

                            Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Party Number ',
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
                                  onValidator: (value) {
                                    if (value!.isEmpty) {
                                      controller.err.value =
                                          'Party Number is Mandatory';
                                      return '';
                                    }

                                    return null;
                                  },
                                  hintText:
                                      'Enter Unique Party Number (EX. WF-100)',
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
                                      'GST Number',
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
                                  hintText: 'Enter GST Number',
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
                                      'Phone Number',
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
                                  hintText: 'Enter Phone Number',
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
                                      'Email',
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
                                  hintText: 'Enter Email address',
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
                                      'Address',
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
                                  hintText: 'Enter Full Address',
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
                                      'Brokers\'s name',
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
                            : CustomBtn(
                                title: partyModel != null
                                    ? 'Update Party'
                                    : 'Submit Party',
                                onTap: () {
                                  controller.err.value = '';
                                  if (formKey.currentState!.validate()) {
                                    if (partyModel != null) {
                                      controller.updateParty();
                                    } else {
                                      controller.createNewParty();
                                    }
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: 12),

                      if (partyModel != null)
                        CustomBtnRed(
                          title: 'Delete',
                          onTap: () {
                            Get.dialog(DeletePartyDialog());
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
      ),
    );
  }

  Text _mark() {
    return Text(
      '*',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.errorColor,
      ),
    );
  }
}
