import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/app_text_styles.dart';
import 'package:texmunimx/models/labour_cost_model.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/formate_double.dart';

class LabourCostCard extends StatelessWidget {
  final bool isMain;
  const LabourCostCard({super.key, required this.item, this.isMain = false});

  final LabourCostModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isMain
            ? AppColors.mainColor.withAlpha(100)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(item.paisa.toStringAsFixed(2)),
              ),
            ),

            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  formatDouble(item.cost),
                  textAlign: TextAlign.end,
                  style: bodyStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
