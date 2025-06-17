import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        baseUrl: "https://olivedrab-llama-457480.hostingersite.com/public/api/",
        receiveDataWhenStatusError: true,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  static Future<Response> postData({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] = token != null ? 'Bearer $token' : '';
    return await dio.post(url, data: data, queryParameters: query);
  }

  static Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String? token,
  }) async {
    dio.options.headers['Authorization'] = token != null ? 'Bearer $token' : '';
    return await dio.get(url, queryParameters: query);
  }
}
