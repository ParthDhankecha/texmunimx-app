import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/search_field.dart';
import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/screens/create_design/create_design_screen.dart';
import 'package:textile_po/utils/app_colors.dart';

AppBar searchDesignAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 6,
    title: Text(
      'search_design'.tr,
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
                hintText: 'search_design_by'.tr,
                onChanged: (searchText) {
                  Get.find<CreateDesignController>().getDesignList(
                    search: searchText,
                  );
                },
              ),
            ),
            SizedBox(width: 4),
            IconButton(
              onPressed: () {
                Get.to(() => CreateDesignScreen());
              },
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
