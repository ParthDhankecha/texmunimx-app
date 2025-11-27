import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/common_widgets/input_field.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/common_widgets/red_mark.dart';
import 'package:texmunimx/models/sari_matching_model.dart';
import 'package:texmunimx/utils/app_colors.dart';

class SariMatchingCard extends StatelessWidget {
  final SariMatchingModel model;
  final int index;
  final Function()? onRemove;
  final Function(String value)? onColor1Change;
  final Function(String value)? onColor2Change;
  final Function(String value)? onColor3Change;
  final Function(String value)? onColor4Change;
  final Function(String value)? onRateChange;
  final Function(String value)? onQuantityChange;
  final Function(String value)? onColor1QuantityChange;
  final Function(String value)? onColor2QuantityChange;
  final Function(String value)? onColor3QuantityChange;
  final Function(String value)? onColor4QuantityChange;
  const SariMatchingCard({
    super.key,
    required this.model,
    this.onRemove,
    required this.index,
    this.onColor1Change,
    this.onColor2Change,
    this.onColor3Change,
    this.onColor4Change,
    this.onRateChange,
    this.onQuantityChange,
    this.onColor1QuantityChange,
    this.onColor2QuantityChange,
    this.onColor3QuantityChange,
    this.onColor4QuantityChange,
  });

  @override
  Widget build(BuildContext context) {
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
                  MyText('Matching', append: ' ${index + 1}', style: bodyStyle),
                  model.isLocked == true
                      ? SizedBox.shrink()
                      : IconButton(
                          onPressed: onRemove,
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.errorColor,
                          ),
                        ),
                ],
              ),

              //color1 rows
              buildColorRateField(
                colorsLable: '${'color'.tr} 1',
                onColorChange: onColor1Change,
                onRateChange: onColor1QuantityChange,
                initialColorValue: model.color1,
                initialRateValue: '${model.color1Quantity ?? ''}',
              ),
              SizedBox(height: 10),
              //color2 rows
              buildColorRateField(
                colorsLable: '${'color'.tr} 2',
                onColorChange: onColor2Change,
                onRateChange: onColor2QuantityChange,
                initialColorValue: model.color2,
                initialRateValue: '${model.color2Quantity ?? ''}',
              ),
              SizedBox(height: 10),
              //color3 rows
              buildColorRateField(
                colorsLable: '${'color'.tr} 3',
                onColorChange: onColor3Change,
                onRateChange: onColor3QuantityChange,
                initialColorValue: model.color3,
                initialRateValue: '${model.color3Quantity ?? ''}',
              ),
              SizedBox(height: 10),
              //color4 rows
              buildColorRateField(
                colorsLable: '${'color'.tr} 4',
                onColorChange: onColor4Change,
                onRateChange: onColor4QuantityChange,
                initialColorValue: model.color4,
                initialRateValue: '${model.color4Quantity ?? ''}',
              ),
              SizedBox(height: 10),
              //rate
              Row(
                children: [
                  Text(
                    'rate'.tr,
                    textAlign: TextAlign.start,
                    style: normalTextStyle,
                  ),
                  SizedBox(width: 4),
                  RedMark(),
                ],
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      hintText: 'rate'.tr,
                      textAlign: TextAlign.left,
                      onTextChange: onRateChange,
                      textInputType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      initialValue: '${model.rate ?? ''}',
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

  buildColorRateField({
    String? colorsLable,
    String? initialColorValue,
    String? initialRateValue,
    Function(String value)? onColorChange,
    Function(String value)? onRateChange,
  }) {
    return Column(
      children: [
        Row(children: [Text(colorsLable ?? '', style: normalTextStyle)]),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InputField(
                    hintText: 'color'.tr,
                    textAlign: TextAlign.left,
                    onTextChange: onColorChange,
                    initialValue: initialColorValue ?? '',
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  InputField(
                    hintText: 'quantity'.tr,
                    textAlign: TextAlign.left,
                    onTextChange: onRateChange,
                    textInputType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),

                    initialValue: initialRateValue ?? '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
