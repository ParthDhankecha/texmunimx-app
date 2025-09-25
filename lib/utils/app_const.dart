class AppConst {
  //base url
  static String baseUrl = 'http://192.168.29.74:3000/api/v1/device/';

  static String imageBaseUrl = '';

  //apis
  static String defaultConfig = 'sync/'; // method  -get
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

  //purchase orders
  static String purchaseOrderCreate = 'purchase-order/create'; //post
  // panna, process, designId, partyId, quantity, rate, optinal - deliveryDate, highPrority
  static String purchaseOrderList = 'purchase-order/list'; // post
  static String purchaseOrderUpdate = 'purchase-order/update'; // put - {id}
  static String purchaseOrderDelete = 'purchase-order/delete'; // delete - {id}
  static String purchaseOrder = 'purchase-order/delete'; // delete - {id}
  static String purchaseOrderGetOptions = 'purchase-order/get-options'; //get
  static String purchaseOrderChangeStatus =
      'purchase-order/change-status'; //put with id

  //calculator
  //design/design-details/{id}  - get
  static String designDetails = 'design-detail'; // get with id
  static String calculatorSave = 'design-detail/upsert'; // get with id
  //designId,

  static String getAssetPng(String name) {
    return 'assets/images/$name.png';
  }

  static String placeHolderImage = '';
}
