import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showErrorSnackbar(String title, {String? decs}) {
  Get.snackbar(
    title, // Title of the SnackBar
    decs ?? '', // Message content
    snackPosition: SnackPosition.TOP, // Position of the SnackBar
    backgroundColor: Colors.red, // Background color for error indication
    colorText: Colors.white, // Text color
    // Optional icon
    duration: const Duration(seconds: 3), // Duration the SnackBar is visible
    messageText: decs != null
        ? Text(decs, style: const TextStyle(color: Colors.white))
        : SizedBox.shrink(),
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
  );
}
