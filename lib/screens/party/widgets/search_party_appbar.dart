import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/search_field.dart';
import 'package:texmunimx/controllers/party_controller.dart';
import 'package:texmunimx/screens/party/create_party.dart';
import 'package:texmunimx/utils/app_colors.dart';

AppBar searchPartyAppbar() {
  return AppBar(
    centerTitle: true,
    elevation: 6,
    title: Text(
      'search_parties'.tr,
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
                hintText: 'search_party_by'.tr,
                onChanged: (searchText) {
                  Get.find<PartyController>().searchQuery.value = searchText;
                },
              ),
            ),
            SizedBox(width: 4),
            IconButton(
              onPressed: () {
                Get.to(() => CreatePartyScreen());
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
  );
}
