import 'package:flutter/material.dart';
import 'package:texmunimx/utils/app_colors.dart';

class CustomBtn extends StatelessWidget {
  final String title;
  final Function()? onTap;
  final bool isOutline;
  final bool isSmall;

  const CustomBtn({
    super.key,
    required this.title,
    this.onTap,
    this.isOutline = false,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return isSmall
        ? InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isOutline ? null : AppColors.mainColor,
                border: isOutline
                    ? Border.all(color: AppColors.mainColor, width: 0.75)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 6.0,
                ),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isOutline
                          ? AppColors.mainColor
                          : AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: isOutline ? null : AppColors.mainColor,
                border: isOutline
                    ? Border.all(color: AppColors.mainColor, width: 2)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: isOutline
                          ? AppColors.mainColor
                          : AppColors.whiteColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
