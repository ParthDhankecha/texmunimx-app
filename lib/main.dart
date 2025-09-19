import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile_po/controllers/localization_controller.dart';
import 'package:textile_po/screens/splash_screen.dart';
import 'package:textile_po/utils/app_strings.dart';
import 'package:textile_po/utils/internationalization.dart';
import 'utils/get_di.dart' as getit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getit.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  final LocalizationController localizationController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      translations: AppTranslations(), // translations
      //locale: Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale('en', 'US'), //
      home: const SplashScreen(),
    );
  }
}
