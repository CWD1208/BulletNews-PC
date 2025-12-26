import 'package:stockc/core/constants/api_endpoints.dart';
import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/data/models/user_model.dart';

class AuthRepository {
  final DioClient _client = DioClient();

  Future<void> login(String username, String password) async {
    // Demo implementation
    // In real app: var response = await _client.post(ApiEndpoints.login, data: {'username': username, 'password': password});

    // Simulate generic "get token"
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final fakeToken =
        'ey-simulation-token-${DateTime.now().millisecondsSinceEpoch}';

    // Save token to client so subsequent requests use it
    _client.setToken(fakeToken);
  }

  Future<void> logout() async {
    // await _client.post(ApiEndpoints.logout);
    _client.setToken(null);
  }

  Future<UserModel> autoLogin() async {
    return await _client.get<UserModel>(
      ApiEndpoints.autoLogin,
      fromJson: (json) => UserModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
