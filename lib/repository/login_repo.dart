import 'package:textile_po/models/login_auth_model.dart';
import 'package:textile_po/repository/api_client.dart';
import 'package:textile_po/utils/app_const.dart';

class LoginRepo {
  final ApiClient apiClient;

  LoginRepo({required this.apiClient});
  //api to send otp
  Future<dynamic> sendOtp({required String mobile}) async {
    var reqBody = {'mobile': mobile};

    final data = await apiClient.request(
      AppConst.loginWithMobile,
      method: ApiType.post,
      body: reqBody,
    );

    return data;
  }

  Future<AuthData> verifyOTP({
    required String mobile,
    required String otp,
  }) async {
    var reqBody = {'mobile': mobile, 'otp': otp};

    final data = await apiClient.request(
      AppConst.verifyOTP,
      body: reqBody,
      method: ApiType.post,
    );
    return loginAuthFromMap(data).data;
  }
}
