import 'package:flutter/material.dart';
import 'package:textile_po/utils/app_colors.dart';

class CustomBtnRed extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isOutline;

  const CustomBtnRed({
    super.key,
    required this.title,
    this.onTap,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: isOutline ? null : AppColors.errorColor,
          border: isOutline
              ? Border.all(color: AppColors.errorColor, width: 2)
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: isOutline ? AppColors.errorColor : AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
