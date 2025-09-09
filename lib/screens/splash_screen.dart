import 'package:flutter/material.dart';
import 'package:textile_po/common_widgets/main_btn.dart';
import 'package:textile_po/controllers/splash_controller.dart';
import 'package:textile_po/screens/auth_screens/login_screen.dart';
import 'package:textile_po/utils/app_colors.dart';
import 'package:textile_po/utils/app_strings.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashController splashController = Get.find();

  @override
  void initState() {
    super.initState();
    splashController.checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to ${AppStrings.appName}',
                  style: TextStyle(color: AppColors.mainColor, fontSize: 24),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  MainBtn(
                    label: 'Continue',
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}
