import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.hintText,
    this.textEditingController,
    this.textInputType,
  });

  final String hintText;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Enter Design Name',
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    );
  }
}
