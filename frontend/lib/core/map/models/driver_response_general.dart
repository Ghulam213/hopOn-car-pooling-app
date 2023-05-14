class DriverGeneralResponse {
  int? code;
  String? error;
  String? data;

  DriverGeneralResponse({this.code, this.error, this.data});

  factory DriverGeneralResponse.fromJson(json) {
    return DriverGeneralResponse(
      data: json['data'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'error': error,
        'data': data,
      };
}
