import 'package:flutter/material.dart';
import 'package:textile_po/utils/app_colors.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  const CustomBtn({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.mainColor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
