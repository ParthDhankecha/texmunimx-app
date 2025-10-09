import 'package:flutter/material.dart';

class TextSeparator extends StatelessWidget {
  /// The text to display in the center of the divider.
  final String text;

  /// The color for the divider lines and the text.
  final Color color;

  const TextSeparator({
    super.key,
    this.text = 'AND', // Default text is 'AND' to match the screenshot
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    // The Row layout places the text between two expanded dividers.
    return Row(
      children: <Widget>[
        // --- Left Divider ---
        const Expanded(
          child: Divider(
            color: Colors.black, // Very light gray to match screenshot
            thickness: 1,
          ),
        ),

        // --- Centered Text ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),

        // --- Right Divider ---
        const Expanded(
          child: Divider(
            color: Colors.black, // Very light gray
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
