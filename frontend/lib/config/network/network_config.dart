import 'package:dio/dio.dart';
import 'package:hop_on/config/network/dio_interceptor.dart';

class NetworkConfig {
  static final NetworkConfig _instance = NetworkConfig._internal();

  late Dio dio;

  static const _STAGING_URL = "http://10.0.2.2:3001";

  factory NetworkConfig() {
    return _instance;
  }

  NetworkConfig._internal();

  void initNetworkConfig() {
    late String baseUrl;

    baseUrl = _STAGING_URL;

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ))
      ..interceptors.add(DioInterceptior());
  }
}
