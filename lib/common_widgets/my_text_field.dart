import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyText extends StatelessWidget {
  final String textKey;
  final String append;
  final TextStyle? style;

  const MyText(this.textKey, {super.key, this.append = '', this.style});

  @override
  Widget build(BuildContext context) {
    // Check if the translation key exists

    // for (var element in Get.translations.keys) {
    //   print('element : $element');
    // }
    // var find = Get.translations.entries.contains(
    //   textKey.toLowerCase().replaceAll(' ', '_'),
    // );

    // print('ind : $find -- ${textKey.toLowerCase().replaceAll(' ', '_')}');
    final translatedText = textKey.tr;

    // Combine the translated text with any appended text
    final displayText = translatedText + append;

    // Return a standard Text widget with the final string and styling
    return Text(displayText, style: style);
  }
}
