import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:texmunimx/common_widgets/custom_btn.dart';
import 'package:texmunimx/controllers/purchase_order_controller.dart';
import 'package:texmunimx/models/sari_matching_model.dart';
import 'package:texmunimx/screens/purchase_order/create_po/widgets/delete_job_or_matching_dialog.dart';
import 'package:texmunimx/screens/purchase_order/create_po/sari/sari_matching_card.dart';

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
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: controller.sariMatchingList.length,
            itemBuilder: (context, index) {
              SariMatchingModel model = controller.sariMatchingList[index];
              return SariMatchingCard(
                model: model,
                index: index,
                onRemove: () {
                  if (model.color1 == null ||
                      model.color1!.isEmpty && model.color2 == null ||
                      model.color2!.isEmpty && model.color3 == null ||
                      model.color3!.isEmpty && model.color4 == null ||
                      model.color4!.isEmpty && model.rate == null ||
                      model.rate == 0 && model.quantity == null ||
                      model.quantity == 0) {
                    controller.removeSariMatching(index);
                    return;
                  }
                  Get.dialog(
                    DeleteJobOrMatchingDialog(
                      isJob: false,
                      onDelete: () {
                        controller.removeSariMatching(index);
                      },
                    ),
                  );
                  //controller.removeSariMatching(index);
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
                // getting quantity change
                onColor1QuantityChange: (value) {
                  int val = int.tryParse(value) ?? 0;
                  controller.updateColorQuantity(index, 1, val);
                },
                onColor2QuantityChange: (value) {
                  int val = int.tryParse(value) ?? 0;
                  controller.updateColorQuantity(index, 2, val);
                },
                onColor3QuantityChange: (value) {
                  int val = int.tryParse(value) ?? 0;
                  controller.updateColorQuantity(index, 3, val);
                },
                onColor4QuantityChange: (value) {
                  int val = int.tryParse(value) ?? 0;
                  controller.updateColorQuantity(index, 4, val);
                },
                //getting rate change
                onRateChange: (value) {
                  controller.updateSariRate(index, value);
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
