import 'package:texmunimx/utils/shared_pref.dart';
import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService {
  final Sharedprefs sp;
  RxInt selectedIndex = 0.obs;

  HomeController({required this.sp});

  void changeIndex(int i) {
    selectedIndex.value = i;
  }

  resetSelectedTab() {
    selectedIndex.value = 0;
  }
}
