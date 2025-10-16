import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/custom_network_image.dart';
import 'package:texmunimx/models/design_list_response.dart';
import 'package:texmunimx/utils/app_const.dart';

class DesignCard extends StatelessWidget {
  final DesignModel design;
  final Function()? onDesignSelect;
  const DesignCard({
    super.key,
    required this.design,
    required this.onDesignSelect,
  });

  @override
  Widget build(BuildContext context) {
    log('image - ${AppConst.imageBaseUrl + design.designImage}');
    return InkWell(
      onTap: onDesignSelect,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomNetworkImage(
              imageUrl: design.designImage.isEmpty
                  ? AppConst.imageBaseUrl + AppConst.placeHolderImage
                  : AppConst.imageBaseUrl + design.designImage,
              fit: BoxFit.cover,
            ),
            // Gradient Overlay to improve text readability
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),
            // Text Content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    design.designName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    design.designNumber,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
