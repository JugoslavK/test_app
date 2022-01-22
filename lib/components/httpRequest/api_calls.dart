import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../constant.dart';

var logger = Logger();

/// This is the DIO api call maker. With interceptors and headers.
final Dio dio = Dio()
  // ..options.baseUrl = Environment.baseUrl
  ..options.connectTimeout = 15000
  ..options.receiveTimeout = 5000
  ..interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // Do something before request is sent

    // DEBUG PRINTS
    logger.d(
        "Perform request:\n method: ${options.method.toUpperCase()},\n path:${options.path}, \n baseURL:${options.baseUrl} \n query:${options.queryParameters}");
    logger.d("header:${options.headers} ");
    if (options.data != null) logger.d("Sending body:${options.data} ");
    return handler.next(options); //continue
    // If you want to resolve the request with some custom data，
    // you can resolve a `Response` object eg: return `dio.resolve(response)`.
    // If you want to reject the request with a error message,
    // you can reject a `DioError` object eg: return `dio.reject(dioError)`
  }, onResponse: (response, handler) {
    // Do something with response data
    logger
        .d("(${response.realUri.path}) Responce body: ==> \n ${response.data}");
    return handler.next(response); // continue
    // If you want to reject the request with a error message,
    // you can reject a `DioError` object eg: return `dio.reject(dioError)`
  }, onError: (DioError e, handler) {
    // Do something with response error
    Response response =
        Response(requestOptions: RequestOptions(path: ''), statusCode: 500);
    logger.d('(${e.response?.realUri.path}) Response from server Error ==> ' +
        e.message);
    return handler.resolve(e.response ?? response); //continue
    // If you want to resolve the request with some custom data，
    // you can resolve a `Response` object eg: return `dio.resolve(response)`.
  }));

/// Api calls class for doing all the api calls we need.
class ApiCalls {
  const ApiCalls();

  /// GET api call with query params
  // Future<dynamic> get(String uri, bool isOldBaseUrl) async {
  Future<dynamic> get(String uri, Map<String, dynamic>? queryParameters) async {
    // if (!isOldBaseUrl) {
    //   dio..options.baseUrl = Environment.baseBatUrl;
    // } else {
    //   dio..options.baseUrl = Environment.baseUrl;
    // }
    final Response response =
        await dio.get(uri, queryParameters: queryParameters);
    return response;
  }

  /// POST api call with dynamic data
  // Future<dynamic> post(String uri, dynamic data, bool isOldBaseUrl) async {
  Future<dynamic> post(String uri, dynamic data) async {
    // if (!isOldBaseUrl) {
    //   dio..options.baseUrl = Environment.baseBatUrl;
    // } else {
    //   dio..options.baseUrl = Environment.baseUrl;
    // }
    try {
      logger.d(json.encode(data));
      final Response response;
      if (data != null) {
        response = await dio.post(uri, data: data);
      } else {
        response = await dio.post(uri);
      }
      return response;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.d(e.response?.data ?? "ERROR");
        logger.d(e.response?.headers ?? "ERROR");
        return e.response;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.d(e.message);
      }
    }
  }

  /// DELETE api call
  Future<dynamic> delete(String uri) async {
    try {
      return await dio.delete(uri);
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        logger.d(e.response!.data);
        logger.d(e.response!.headers);
        return e.response;
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        logger.d(e.message);
      }
    }
  }

  /// PUT api call
  Future<dynamic> put(String uri, dynamic data) async {
    try {
      final Response response = await dio.put(uri, data: data);

      return response;
    } catch (e) {
      throw ('An error occurred');
    }
  }
}

const ApiCalls apiCalls = ApiCalls();
