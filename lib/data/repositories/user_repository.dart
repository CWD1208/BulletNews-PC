import 'package:stockc/core/network/dio_client.dart';
import 'package:stockc/core/constants/api_endpoints.dart';
import 'package:stockc/data/models/login_response_model.dart';
import 'package:stockc/data/models/user_model.dart';

class UserRepository {
  final DioClient _client = DioClient();

  Future<AutoLoginResponse> autoLogin(String uuid) async {
    return await _client.post<AutoLoginResponse>(
      ApiEndpoints.autoLogin,
      data: {
        'data': {'account_source_id': uuid, 'source': 3},
      },
      fromJson:
          (json) => AutoLoginResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<UserModel> getProfile() async {
    return await _client.get<UserModel>(
      ApiEndpoints.getProfile,
      fromJson:
          (json) => UserModel.fromJson(json['account'] as Map<String, dynamic>),
    );
  }
}
