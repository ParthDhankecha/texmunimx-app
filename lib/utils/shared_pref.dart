import 'package:shared_preferences/shared_preferences.dart';

class Sharedprefs {
  final SharedPreferences pref;
  Sharedprefs({required this.pref});

  dynamic _getData(String key) {
    var value = pref.get(key);
    return value;
  }

  // Private method for saving data to shared preferences
  void _saveData(String key, dynamic value) {
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

  //rols and its int from config api
  set owner(int i) => _saveData('OWNER', i);
  int get owner => _getData('OWNER') ?? 1;

  set admin(int i) => _saveData('ADMIN', i);
  int get admin => _getData('ADMIN') ?? 2;

  set manager(int i) => _saveData('MANAGER', i);
  int get manager => _getData('MANAGER') ?? 3;

  set job(int i) => _saveData('JOB', i);
  int get job => _getData('JOB') ?? 4;

  //get and set user type
  set userToken(String value) => _saveData('USER_TOKEN', value);
  String get userToken => _getData('USER_TOKEN') ?? '';

  //get and set user role
  set userRole(int value) => _saveData('USER_ROLE', value);
  int get userRole => _getData('USER_ROLE') ?? 0;

  set currentLanguage(String value) => _saveData('USER_LAN', value);
  String get currentLanguage => _getData('USER_LAN') ?? 'en';

  set lastUpdatePromptTime(int value) =>
      _saveData('LAST_UPDATE_PROMPT_TIME', value);
  int get lastUpdatePromptTime => _getData('LAST_UPDATE_PROMPT_TIME') ?? 0;

  // Clear all data from shared preferences
  void clearAll() {
    pref.clear();
  }
}
