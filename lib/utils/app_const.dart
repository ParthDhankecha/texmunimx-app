class AppConst {
  //base url
  static String baseUrl = 'http://192.168.29.162:3001/api/v1/device/';

  static String imageBaseUrl = '';

  //apis
  static String defaultConfig = 'sync/'; // method  -get
  static String loginWithMobile = 'auth/sign-in';
  static String verifyOTP = 'auth/verify-mobile-otp';

  //users
  static String users = 'users/pagination'; // post
  static String usersCreate = 'users'; // post

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

  //purchase orders
  static String purchaseOrderCreate = 'purchase-order/create'; //post
  static String purchaseOrderList = 'purchase-order/list'; // post
  static String purchaseOrderUpdate = 'purchase-order/update'; // put - {id}
  static String purchaseOrderDelete = 'purchase-order/delete'; // delete - {id}
  static String purchaseOrderGetOptions = 'purchase-order/get-options'; //get
  static String purchaseOrderChangeStatus =
      'purchase-order/change-status'; //put with id
  static String purchaseOrder = 'purchase-order'; // get with id
  static String orderHistory = 'purchase-order/history'; // get

  static String firmsCreate = 'firm/create';
  static String firmsUpdate = 'firm/update';
  static String firmsList = 'firm/list'; // post - list
  static String firmsDelete = 'firm/delete'; // delete - {id}

  //calculator
  //design/design-details/{id}  - get
  static String designDetails = 'design-detail'; // get with id
  static String calculatorSave = 'design-detail/upsert'; // get with id

  //designId,

  static String getAssetPng(String name) {
    return 'assets/images/$name.png';
  }

  static String placeHolderImage = '';

  //Roles
  static const String superAdmin = 'SUPER_ADMIN'; //0
  static const String owner = 'OWNER'; //1
  static const String admin = 'ADMIN'; // 2
  static const String manager = 'MANAGER'; //3

  //UaserRoles List
  static List<String> userRoles = [superAdmin, owner, admin, manager];
}
