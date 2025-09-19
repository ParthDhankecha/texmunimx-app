class AppConst {
  //base url
  static String baseUrl = 'http://192.168.29.74:3000/api/v1/device/';

  static String imageBaseUrl = '';

  //apis
  static String defaultConfig = 'device/sync/'; // method  -get
  static String loginWithMobile = 'auth/sign-in-with-mobile/';
  static String verifyOTP = 'auth/verify-mobile-otp';

  // design
  static String createDesign = 'design/create';
  static String listDesign = 'design/list';
  static String listDelete = 'design/delete';
  static String updateDesign = 'design/update'; //put

  //party
  static String createParty = 'party/create';
  static String listParty = 'party/list';
  static String deleteParty = 'party/delete';
  static String updateParty = 'party/update';

  static String getAssetPng(String name) {
    return 'assets/images/$name.png';
  }
}
