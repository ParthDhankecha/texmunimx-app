import 'package:textile_po/models/login_auth_model.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';

class LoginRepo {
  final ApiClient apiClient;

  LoginRepo({required this.apiClient});
  //api to send otp
  Future<LoginModel> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    final reqBody = {'userName': email, 'password': password};

    var data = await apiClient.requestPost(
      AppConst.loginWithMobile,
      body: reqBody,
    );

    LoginModel loginModel = loginResponseFromMap(data).data;
    return loginModel;
  }
}
