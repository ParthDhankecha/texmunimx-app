import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserActiveSwitch extends StatelessWidget {
  final bool isActive;
  final Function(bool) onChanged;
  const UserActiveSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            '${'is_active'.tr}:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        SizedBox(width: 12),

        SizedBox(
          height: 46,
          child: Switch(
            value: isActive,
            onChanged: onChanged,
            activeThumbColor: Colors.green,
          ),
        ),
      ],
    );
  }
}
