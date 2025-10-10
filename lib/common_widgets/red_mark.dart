import 'package:flutter/material.dart';

class RedMark extends StatelessWidget {
  const RedMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '*',
      style: TextStyle(
        color: Colors.red,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
