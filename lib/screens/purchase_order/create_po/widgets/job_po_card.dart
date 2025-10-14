import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/custom_dropdown.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/common_widgets/red_mark.dart';
import 'package:textile_po/models/in_process_model.dart';
import 'package:textile_po/models/job_po_model.dart';
import 'package:textile_po/models/purchase_order_options_response.dart';
import 'package:textile_po/models/sari_matching_model.dart';
import 'package:textile_po/utils/app_colors.dart';

class JobPoCard extends StatelessWidget {
  final JobPoModel model;
  final int index;
  final Function()? onRemove;
  final Function(String value)? userChange;
  final Function(String value)? onFirmChange;
  final Function(String value)? matchingChange;
  final Function(String value)? onRateChange;
  final Function(String value)? onQuantityChange;
  final Function(String value)? onRemarksChange;
  final List<User> users;
  final List<FirmId> firms;
  final List<SariMatchingModel> matchings;

  const JobPoCard({
    super.key,
    required this.model,
    this.onRemove,
    required this.index,

    this.onRateChange,
    this.onQuantityChange,
    this.userChange,
    this.onFirmChange,
    this.matchingChange,
    this.onRemarksChange,
    required this.users,
    required this.firms,
    required this.matchings,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText('job_po', append: ' ${index + 1}', style: bodyStyle),
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.errorColor,
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomDropdown<User>(
                      title: 'job_user'.tr,
                      items: users,
                      selectedValue: model.user == '' || model.user == null
                          ? null
                          : users.firstWhere(
                              (element) => element.id.toString() == model.user,
                              orElse: () =>
                                  User(id: '', fullname: 'Select User'),
                            ),
                      isRequired: true,
                      onChanged: (value) {
                        if (value != null) {
                          userChange?.call(value.id.toString());
                        }
                      },
                      itemLabelBuilder: (User item) => item.fullname,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        CustomDropdown<FirmId>(
                          title: 'firm'.tr,
                          items: firms,
                          isRequired: true,
                          selectedValue: model.firm == '' || model.firm == null
                              ? null
                              : firms.firstWhere(
                                  (element) =>
                                      element.id.toString() == model.firm,
                                  orElse: () =>
                                      FirmId(id: '', firmName: 'Select Firm'),
                                ),
                          onChanged: (value) {
                            if (value != null) {
                              onFirmChange?.call(value.id.toString());
                            }
                          },
                          itemLabelBuilder: (FirmId item) => item.firmName,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        CustomDropdown<SariMatchingModel>(
                          title: 'matching'.tr,
                          items: matchings,
                          isRequired: true,
                          selectedValue:
                              model.matching == '' || model.matching == null
                              ? null
                              : matchings.firstWhere(
                                  (element) =>
                                      element.matching == model.matching,
                                  orElse: () => SariMatchingModel(
                                    id: 0,
                                    matching: 'Select Matching',
                                  ),
                                ),
                          onChanged: (value) {
                            if (value != null) {
                              matchingChange?.call(value.matching!);
                            }
                          },
                          itemLabelBuilder: (SariMatchingModel item) =>
                              item.matching!,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('quantity'.tr, style: normalTextStyle),
                            RedMark(),
                          ],
                        ),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onQuantityChange,
                          textInputType: TextInputType.number,
                          // textEditingController: TextEditingController(
                          //   text: model.quantity?.toString() ?? '',
                          // ),
                          initialValue: model.quantity?.toString() ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('remarks'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onRemarksChange,
                          textInputType: TextInputType.text,
                          // textEditingController: TextEditingController(
                          //   text: model.remarks ?? '',
                          // ),
                          initialValue: model.remarks ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
