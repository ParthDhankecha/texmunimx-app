import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/utils/app_colors.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.labelText = 'Password',
    this.validator,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  // Observable to manage password visibility state
  final RxBool _isPasswordVisible = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: widget.controller,
          obscureText: !_isPasswordVisible.value,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Enter your password',

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black38),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.mainColor),
            ),
            hintStyle: TextStyle(color: AppColors.blackColor),
            labelStyle: TextStyle(color: AppColors.blackColor),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () {
                _isPasswordVisible.value = !_isPasswordVisible.value;
              },
            ),
          ),
          validator: widget.validator,
        ),
      ),
    );
  }
}
