import 'package:dio/dio.dart';
import 'package:hop_on/config/network/dio_interceptor.dart';

class NetworkConfig {
  static final NetworkConfig _instance = NetworkConfig._internal();

  late Dio dio;

  static const _STAGING_URL = "http://localhost:3001";
  //  https://hopon-be-g6jr7t55pq-ew.a.run.app deployed

  static const _STAGING_URL_IOS = "http://localhost:3001";

  factory NetworkConfig() {
    return _instance;
  }

  NetworkConfig._internal();

  void initNetworkConfig() {
    late String baseUrl;

    baseUrl = NetworkConfig._STAGING_URL;

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ))
      ..interceptors.add(DioInterceptior());
  }
}
