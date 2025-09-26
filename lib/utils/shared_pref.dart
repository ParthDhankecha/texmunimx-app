import 'package:shared_preferences/shared_preferences.dart';

class Sharedprefs {
  final SharedPreferences pref;
  Sharedprefs({required this.pref});

  // Private generic method for retrieving data from shared preferences
  dynamic _getData(String key) {
    // Retrieve data from shared preferences
    var value = pref.get(key);

    // Easily log the data that we retrieve from shared preferences

    // Return the data that we retrieve from shared preferences
    return value;
  }

  // Private method for saving data to shared preferences
  void _saveData(String key, dynamic value) {
    // Easily log the data that we save to shared preferences

    // Save data to shared preferences
    if (value is String) {
      pref.setString(key, value);
    } else if (value is int) {
      pref.setInt(key, value);
    } else if (value is double) {
      pref.setDouble(key, value);
    } else if (value is bool) {
      pref.setBool(key, value);
    } else if (value is List<String>) {
      pref.setStringList(key, value);
    }
  }

  //get and set user type
  set userToken(String value) => _saveData('USER_TOKEN', value);
  String get userToken => _getData('USER_TOKEN') ?? '';

  //get and set user role
  set userRole(String value) => _saveData('USER_ROLE', value);
  String get userRole => _getData('USER_ROLE') ?? '';

  set userRoleInt(int value) => _saveData('USER_ROLE_INT', value);
  int get userRoleInt => _getData('USER_ROLE_INT') ?? 0;

  set currentLanguage(String value) => _saveData('USER_LAN', value);
  String get currentLanguage => _getData('USER_LAN') ?? 'en';

  // Clear all data from shared preferences
  void clearAll() {
    pref.clear();
  }
}
