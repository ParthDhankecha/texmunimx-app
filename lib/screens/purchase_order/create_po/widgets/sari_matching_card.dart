import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/common_widgets/red_mark.dart';
import 'package:textile_po/models/cal_weft_model.dart';
import 'package:textile_po/models/sari_matching_model.dart';
import 'package:textile_po/utils/app_colors.dart';

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
                  MyText('Matching', append: ' ${index + 1}', style: bodyStyle),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('color1'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,
                          onTextChange: onColor1Change,
                          // textEditingController: TextEditingController(
                          //   text: model.color1 ?? '',
                          // ),
                          initialValue: model.color1 ?? '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text('color2'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onColor2Change,
                          textInputType: TextInputType.number,
                          // textEditingController: TextEditingController(
                          //   text: model.color2?.toString() ?? '',
                          // ),
                          initialValue: model.color2 ?? '',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('color3'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onColor3Change,
                          textInputType: TextInputType.number,
                          initialValue: model.color3?.toString() ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('color4'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onColor4Change,
                          textInputType: TextInputType.number,
                          // textEditingController: TextEditingController(
                          //   text: model.color4?.toString() ?? '',
                          // ),
                          initialValue: model.color4 ?? '',
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
                            Text('rate'.tr, style: normalTextStyle),
                            RedMark(),
                          ],
                        ),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onRateChange,
                          textInputType: TextInputType.number,
                          initialValue: model.rate?.toString() ?? '',
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
                          initialValue: model.quantity?.toString() ?? '',
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
