import 'package:flutter/material.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/app_const.dart';

class SettingsCard extends StatelessWidget {
  final String img;
  final String title;
  final Function() onTap;
  const SettingsCard({
    super.key,
    required this.img,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: AppColors.mainColor,
        elevation: 6,
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: Image.asset(
            AppConst.getAssetPng(img),
            height: 36,
            width: 36,
            color: Colors.white,
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }
}
