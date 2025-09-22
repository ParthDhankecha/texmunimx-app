import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.textInputType,
    this.onValidator,
  });

  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;
  final String? Function(String? value)? onValidator;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF9F9FA),
      child: TextFormField(
        validator: onValidator,
        controller: textEditingController,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black38),
          ),
        ),
      ),
    );
  }
}
