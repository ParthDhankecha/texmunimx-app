import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/app_text_styles.dart';
import 'package:textile_po/common_widgets/input_field.dart';
import 'package:textile_po/common_widgets/my_text_field.dart';
import 'package:textile_po/models/cal_weft_model.dart';
import 'package:textile_po/utils/app_colors.dart';

class WeftItemCard extends StatelessWidget {
  final CalWeftModel model;
  final int index;
  final Function()? onRemove;
  final Function(String value)? onChangeQuality;
  final Function(String value)? onDenierChange;
  final Function(String value)? onPickChange;
  final Function(String value)? onPannoChange;
  final Function(String value)? onRateChange;
  final Function(String value)? onMeterChange;
  const WeftItemCard({
    super.key,
    required this.model,
    this.onRemove,
    required this.index,
    this.onChangeQuality,
    this.onDenierChange,
    this.onPickChange,
    this.onPannoChange,
    this.onRateChange,
    this.onMeterChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Card(
        elevation: 6,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText('feeder', append: ' ${index + 1}', style: bodyStyle),
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
                      children: [
                        Text('quality'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,
                          onTextChange: onChangeQuality,
                          textEditingController: TextEditingController(
                            text: model.quality ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text('denier'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onDenierChange,
                          textInputType: TextInputType.number,
                          textEditingController: TextEditingController(
                            text: model.denier?.toString() ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text('pick'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onPickChange,
                          textInputType: TextInputType.number,
                          textEditingController: TextEditingController(
                            text: model.pick?.toString() ?? '',
                          ),
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
                      children: [
                        Text('panno'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onPannoChange,
                          textInputType: TextInputType.number,
                          textEditingController: TextEditingController(
                            text: model.panno?.toString() ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text('rate'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onRateChange,
                          textInputType: TextInputType.number,
                          textEditingController: TextEditingController(
                            text: model.rate?.toString() ?? '',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      children: [
                        Text('meter'.tr, style: normalTextStyle),
                        InputField(
                          hintText: '',
                          textAlign: TextAlign.center,

                          onTextChange: onMeterChange,
                          textInputType: TextInputType.number,
                          textEditingController: TextEditingController(
                            text: model.meter?.toString() ?? '',
                          ),
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
