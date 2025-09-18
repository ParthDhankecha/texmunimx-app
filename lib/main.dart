import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:textile_po/screens/splash_screen.dart';
import 'package:textile_po/utils/app_strings.dart';
import 'utils/get_di.dart' as getit;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getit.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue),
      ),
      home: const SplashScreen(),
    );
  }
}
