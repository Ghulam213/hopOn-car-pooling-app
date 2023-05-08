class RequestRideResponse {
  int? statusCode;
  String? error;
  String? data;

  RequestRideResponse({this.statusCode, this.error, this.data});

  factory RequestRideResponse.fromJson(json) {
    return RequestRideResponse(
      statusCode: json['statusCode'] as int?,
      error: json['message'] as String?,
      data: json['data'] as String?,
    );
  }
}
