import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/custom_dropdown.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/models/in_process_model.dart';
import 'package:texmunimx/models/job_po_model.dart';
import 'package:texmunimx/models/purchase_order_options_response.dart';
import 'package:texmunimx/models/sari_color_model.dart';
import 'package:texmunimx/models/sari_matching_model.dart';
import 'package:texmunimx/utils/app_colors.dart';

class JobPoCard extends StatefulWidget {
  final JobPoModel model;
  final int index;
  final Function()? onRemove;
  final Function(String value)? userChange;
  final Function(String value)? onFirmChange;
  final Function(String value)? matchingChange;
  final Function(String value)? onColorChange;
  final Function(String value)? onRateChange;
  final Function(String value)? onQuantityChange;
  final Function(String value)? onRemarksChange;
  final List<User> users;
  final List<FirmId> firms;
  final List<SariMatchingModel> matchings;
  //final List<SariColorModel> colors;
  final bool isLocked;

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
    this.isLocked = false,
    this.onColorChange,
    // required this.colors,
  });

  @override
  State<JobPoCard> createState() => _JobPoCardState();
}

class _JobPoCardState extends State<JobPoCard> {
  List<SariColorModel> colors = [];

  buildColorList() {
    List<SariColorModel> tempList = [];
    SariMatchingModel matchingModel = widget.matchings.firstWhere(
      (element) => element.id.toString() == widget.model.mId,
      orElse: () => SariMatchingModel(id: 0, matching: 'Select Matching'),
    );

    if (matchingModel.color1 != null && matchingModel.color1!.isNotEmpty) {
      tempList.add(
        SariColorModel(
          cid: 1,
          color: matchingModel.color1!,
          quantity: matchingModel.color1Quantity ?? 0,
        ),
      );
    }
    if (matchingModel.color2 != null && matchingModel.color2!.isNotEmpty) {
      tempList.add(
        SariColorModel(
          cid: 2,
          color: matchingModel.color2!,
          quantity: matchingModel.color2Quantity ?? 0,
        ),
      );
    }
    if (matchingModel.color3 != null && matchingModel.color3!.isNotEmpty) {
      tempList.add(
        SariColorModel(
          cid: 3,
          color: matchingModel.color3!,
          quantity: matchingModel.color3Quantity ?? 0,
        ),
      );
    }
    if (matchingModel.color4 != null && matchingModel.color4!.isNotEmpty) {
      tempList.add(
        SariColorModel(
          cid: 4,
          color: matchingModel.color4!,
          quantity: matchingModel.color4Quantity ?? 0,
        ),
      );
    }
    colors = tempList;
    //jobColorsList.refresh();

    for (var i = 0; i < colors.length; i++) {}
  }

  @override
  Widget build(BuildContext context) {
    buildColorList();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(6),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(
                    'job_po',
                    append: ' ${widget.index + 1}',
                    style: bodyStyle,
                  ),
                  if (!widget.isLocked)
                    IconButton(
                      onPressed: widget.onRemove,
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
                      items: widget.users,
                      isEnabled: !widget.isLocked,
                      selectedValue:
                          widget.model.user == '' || widget.model.user == null
                          ? null
                          : widget.users.firstWhere(
                              (element) =>
                                  element.id.toString() == widget.model.user,
                              orElse: () =>
                                  User(id: '', fullname: 'Select User'),
                            ),
                      isRequired: true,
                      onChanged: (value) {
                        if (value != null) {
                          widget.userChange?.call(value.id.toString());
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
                          items: widget.firms,
                          isRequired: true,
                          isEnabled: !widget.isLocked,
                          selectedValue:
                              widget.model.firm == '' ||
                                  widget.model.firm == null
                              ? null
                              : widget.firms.firstWhere(
                                  (element) =>
                                      element.id.toString() ==
                                      widget.model.firm,
                                  orElse: () =>
                                      FirmId(id: '', firmName: 'Select Firm'),
                                ),
                          onChanged: (value) {
                            if (value != null) {
                              widget.onFirmChange?.call(value.id.toString());
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
                          items: widget.matchings,
                          isEnabled: !widget.isLocked,
                          isRequired: true,
                          selectedValue:
                              widget.model.matching == '' ||
                                  widget.model.matching == null
                              ? null
                              : widget.matchings.firstWhere(
                                  (element) =>
                                      element.matching == widget.model.matching,
                                  orElse: () => SariMatchingModel(
                                    id: 0,
                                    matching: 'Select Matching',
                                  ),
                                ),
                          onChanged: (value) {
                            if (value != null) {
                              widget.matchingChange?.call(value.matching!);
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
                        //for only color id
                        CustomDropdown<SariColorModel>(
                          title: 'color'.tr,
                          items: colors,
                          isRequired: true,
                          isEnabled: !widget.isLocked,
                          selectedValue:
                              widget.model.jobColor == '' ||
                                  widget.model.jobColor == null
                              ? null
                              : colors.firstWhere(
                                  (element) =>
                                      element.cid.toString() ==
                                      widget.model.jobColor,
                                  orElse: () => SariColorModel(
                                    id: '',
                                    color: 'Select Color',
                                  ),
                                ),
                          onChanged: (value) {
                            if (value != null) {
                              widget.onColorChange?.call(value.cid.toString());
                            }
                          },
                          itemLabelBuilder: (SariColorModel item) =>
                              item.color!,
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
                        Row(
                          children: [
                            Text('quantity'.tr, style: normalTextStyle),
                            SizedBox(width: 4),
                            RedMark(),
                          ],
                        ),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.left,
                          onTextChange: widget.onQuantityChange,
                          textInputType: TextInputType.number,
                          initialValue: widget.model.quantity?.toString() ?? '',
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('remarks'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.left,

                          onTextChange: widget.onRemarksChange,
                          textInputType: TextInputType.text,

                          initialValue: widget.model.remarks ?? '',
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
