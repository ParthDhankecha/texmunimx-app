import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/create_design_controller.dart';
import 'package:textile_po/screens/create_design/widgets/design_grid_card.dart';
import 'package:textile_po/screens/create_design/widgets/search_design_appbar.dart';
import 'package:textile_po/utils/app_const.dart';

class DesignListScreen extends StatefulWidget {
  const DesignListScreen({super.key});

  @override
  State<DesignListScreen> createState() => _DesignListScreenState();
}

class _DesignListScreenState extends State<DesignListScreen> {
  CreateDesignController controller = Get.find<CreateDesignController>();

  @override
  void initState() {
    super.initState();
    controller.getDesignList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchDesignAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? CircularProgressIndicator()
            : GridView.builder(
                padding: const EdgeInsets.all(16.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 0.8, // Adjust as needed to fit the content
                ),
                itemCount: controller.designList.length,
                itemBuilder: (context, index) {
                  var design = controller.designList[index];
                  print('img : ${AppConst.imageBaseUrl}${design.designImage}');
                  return DesignCard(design: design);
                },
              ),
      ),
    );
  }
}
