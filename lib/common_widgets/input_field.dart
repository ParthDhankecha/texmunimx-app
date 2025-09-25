import 'package:flutter/material.dart';
import 'package:textile_po/utils/app_colors.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.textInputType,
    this.onValidator,
    this.onTextChange,
    this.textAlign,
  });

  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? Function(String? value)? onValidator;
  final Function(String value)? onTextChange;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        validator: onValidator,
        textAlign: textAlign ?? TextAlign.start,
        controller: textEditingController,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 14),
        onChanged: onTextChange,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.mainColor),
          ),
        ),
      ),
    );
  }
}
