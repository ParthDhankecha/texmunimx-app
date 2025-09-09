import 'package:image_picker/image_picker.dart';
import 'package:textile_po/utils/shared_pref.dart';
import 'package:get/get.dart';

class HomeController extends GetxController implements GetxService {
  final Sharedprefs sp;
  RxInt selectedIndex = 0.obs;

  HomeController({required this.sp});

  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

  void changeIndex(int i) {
    selectedIndex.value = i;
  }

  void setImage(XFile? img) {
    selectedImage.value = img;
  }
}
