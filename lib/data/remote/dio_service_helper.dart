import 'package:dio/dio.dart';

class DioServiceHelper {
  static Dio? dio;

  static init({required String url}) {
    dio = Dio(BaseOptions(
      baseUrl: url,
      receiveDataWhenStatusError: true,
    ));
  }

  static Future<Response<dynamic>> getData({
    required String endPoint,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    dio!.options.headers = headers ?? {};
    var result = await dio!.get(endPoint, queryParameters: query);
    return result;
  }

  static Future<Response<dynamic>> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
  }) async {
    dio!.options.headers = headers ?? {};
    var result = await dio!.post(url, queryParameters: query, data: data);
    return result;
  }
}
