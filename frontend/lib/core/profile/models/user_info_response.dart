import 'package:hop_on/core/profile/models/user_model.dart';

class UserInfoResponse {
  int? code;
  String? error;
  UserData? data;

  UserInfoResponse({this.code, this.error, this.data});

  factory UserInfoResponse.fromJson(Map<String, dynamic> json) {
    return UserInfoResponse(
      code: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data?.toJson(),
      };
}
