import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/models/design_list_response.dart';
import 'package:textile_po/screens/create_design/create_design_screen.dart';
import 'package:textile_po/utils/app_const.dart';

class DesignCard extends StatelessWidget {
  final DesignModel design;
  const DesignCard({super.key, required this.design});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => CreateDesignScreen(designModel: design));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 4.0,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            FadeInImage(
              //placeholder: const AssetImage('assets/placeholder.png'),
              placeholder: AssetImage('assets/images/placeholder.png'),
              image: NetworkImage(AppConst.imageBaseUrl + design.designImage),
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  ),
                );
              },
            ),
            // Gradient Overlay to improve text readability
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
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
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Ready for production',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
