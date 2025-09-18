import 'package:flutter/material.dart';
import 'package:textile_po/utils/app_colors.dart';

class ErrorRow extends StatelessWidget {
  const ErrorRow({super.key, required this.title, this.desc});
  final String title;
  final String? desc;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.errorColor.withAlpha(50),
            ),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.errorColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
