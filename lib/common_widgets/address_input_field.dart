import 'package:flutter/material.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField({
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xffF9F9FA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black26),
      ),
      child: TextField(
        controller: textEditingController,
        keyboardType: textInputType,
        style: const TextStyle(fontSize: 14),
        maxLines: 5,
        minLines: 3,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none, // Remove the default border
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
