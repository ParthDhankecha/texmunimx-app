import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';
import 'package:texmunimx/utils/app_colors.dart';

class NotesRow extends StatelessWidget {
  final String notes;
  const NotesRow({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText('note', append: ' : '),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300, width: 0.25),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Wrap(
              alignment: WrapAlignment.end,
              children: [
                Text(
                  notes,
                  style: TextStyle(fontSize: 14, color: AppColors.mainColor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
