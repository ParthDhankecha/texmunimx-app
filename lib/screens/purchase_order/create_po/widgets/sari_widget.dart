import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/common_widgets/custom_btn.dart';
import 'package:textile_po/controllers/purchase_order_controller.dart';
import 'package:textile_po/models/sari_matching_model.dart';
import 'package:textile_po/screens/purchase_order/create_po/widgets/sari_matching_card.dart';

class SariWidget extends StatefulWidget {
  const SariWidget({super.key});

  @override
  State<SariWidget> createState() => _SariWidgetState();
}

class _SariWidgetState extends State<SariWidget> {
  PurchaseOrderController controller = Get.find<PurchaseOrderController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.sariMatchingList.length,
            itemBuilder: (context, index) {
              SariMatchingModel model = controller.sariMatchingList[index];
              return SariMatchingCard(
                model: model,
                index: index,
                onRemove: () {
                  controller.removeSariMatching(index);
                },
                onColor1Change: (value) {
                  controller.updateSariColor1(index, value);
                },
                onColor2Change: (value) {
                  controller.updateSariColor2(index, value);
                },
                onColor3Change: (value) {
                  controller.updateSariColor3(index, value);
                },
                onColor4Change: (value) {
                  controller.updateSariColor4(index, value);
                },
                onRateChange: (value) {
                  controller.updateSariRate(index, value);
                },
                onQuantityChange: (value) {
                  controller.updateSariQuantity(index, value);
                },
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomBtn(
                title: 'Add New',
                onTap: () {
                  controller.addNewSariMatching();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
