import 'package:flutter/material.dart';
import 'package:texmunimx/controllers/splash_controller.dart';
import 'package:texmunimx/utils/app_colors.dart';
import 'package:texmunimx/utils/app_const.dart';
import 'package:texmunimx/utils/app_strings.dart';
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
    splashController.getDefaultConfig();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 220,
                child: Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.asset(
                        AppConst.getAssetPng('logo_tr'),
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      bottom: 20,
                      right: 0,
                      left: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.appName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Obx(
              () => Center(
                child: splashController.isLoading.value
                    ? SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
