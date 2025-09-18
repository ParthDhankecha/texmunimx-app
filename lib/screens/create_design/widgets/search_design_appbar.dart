import 'package:flutter/material.dart';
import 'package:textile_po/common_widgets/search_field.dart';
import 'package:textile_po/utils/app_colors.dart';

AppBar searchDesignAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 6,
    title: Text(
      'Search Design',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
    ),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: SearchField(
                hintText: 'Search Designs by name or numbers..',
              ),
            ),
            SizedBox(width: 4),
            IconButton(
              onPressed: () {},
              icon: Container(
                padding: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.add_outlined, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.notifications_outlined,
          color: AppColors.mainColor,
          size: 32,
        ),
      ),
    ],
  );
}
