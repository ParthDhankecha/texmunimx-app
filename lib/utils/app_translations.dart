import 'package:get/get.dart';
import 'package:texmunimx/utils/lan/en_us.dart';
import 'package:texmunimx/utils/lan/gu_in.dart';
import 'package:texmunimx/utils/lan/hi_in.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUs,
    'hi_IN': hiIn,
    'gu_IN': guIn,
  };
}
