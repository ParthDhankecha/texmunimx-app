import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'language_change': 'Change Language',
      'english': 'English',
      'hindi': 'Hindi',
      'gujarati': 'Gujarati',
    },
    'hi_IN': {
      'language_change': 'भाषा बदलें',
      'english': 'अंग्रेज़ी',
      'hindi': 'हिंदी',
      'gujarati': 'गुजराती',
    },
    'gu_IN': {
      'language_change': 'ભાષા બદલો',
      'english': 'અંગ્રેજી',
      'hindi': 'હિન્દી',
      'gujarati': 'ગુજરાતી',
    },
  };
}
