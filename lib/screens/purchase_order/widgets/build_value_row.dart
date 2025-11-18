import 'package:flutter/material.dart';
import 'package:texmunimx/common_widgets/my_text_field.dart';

class BuildValueRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final bool isVisible;
  const BuildValueRow({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    print('ValueRow: $title - $value - isVisible: $isVisible');
    return value.isEmpty
        ? SizedBox.shrink()
        : isVisible
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyText(title, append: ' : '),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: valueColor ?? Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
            ],
          )
        : SizedBox.shrink();
  }
}
