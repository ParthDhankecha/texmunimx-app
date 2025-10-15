import 'package:texmunimx/models/login_auth_model.dart';
import 'package:texmunimx/repository/api_client.dart';
import 'package:texmunimx/utils/app_const.dart';

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
