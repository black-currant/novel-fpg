import 'dart:convert';
import 'dart:io';

import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/app/server_api_code.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// 本应用的HTTP拦截器
/// 处理特殊请求头，解析响应体，处理非actionOK情况。
class MyInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // super.onRequest(options, handler);
    debugPrint('*** Request On MyInterceptor ***');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // super.onResponse(response, handler);
    debugPrint('*** Response On MyInterceptor ***');
    if (response.requestOptions.data != null &&
        (response.requestOptions.data as Map).containsKey('action')) {
      debugPrint('action = ${response.requestOptions.data['action']}');
    }
    // devLog('${response.data}');

    Map<String, dynamic>? data;
    debugPrint('response.data.runtimeType = ${response.data.runtimeType}.');
    if (response.data is String && (response.data as String).isNotEmpty) {
      data = jsonDecode(response.data);
    } else if (response.data is Map && (response.data as Map).isNotEmpty) {
      data = response.data;
    } else {
      // 其他数据类型不解析为JSON，比如二进制
      handler.next(response);
      return;
    }

    if (!data!.containsKey('code')) {
      /// 处理特殊返回值，包括书籍类型，签到，阅读时长上报，消耗书币等接口。
      handler.next(response);
      return;
    }

    RespData respData = RespData.fromJson(data);
    if (respData.succeeded) {
      response.statusCode = respData.code;
      response.statusMessage = respData.message;
      response.data = respData.data;
      // cacheResponse(response);
      handler.next(response);
    } else {
      handler.reject(
        DioError(
          requestOptions: response.requestOptions,
          response: response,
          error: respData,
        ),
        true,
      );
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // super.onError(err, handler);
    debugPrint('*** Error On MyInterceptor ***');

    print('err.message = ${err.message}');

    if (err.error != null) {
      if (err.error is SocketException || err.error is HandshakeException) {
        /// Network is unreachable，check cache.
        Response? response = fetchCache(err.requestOptions);
        if (response != null) handler.resolve(response);
      }
    }
    handler.reject(err);
  }

  /// 缓存key
  String getCacheKey(RequestOptions options) {
    Map map = options.data;
    String action = map['action'];

    /// 处理分页接口的key
    Map data = map.containsKey('data') ? map['data'] : {};
    String params = '';
    data.forEach((key, value) {
      params = params + '&$key=$value';
    });
    String cacheKey;
    if (params.isEmpty) {
      cacheKey = options.baseUrl + options.path + '/$action';
    } else {
      params = params.substring(1); // 删除第一个&符号
      cacheKey = options.baseUrl + options.path + '/$action?$params';
    }
    return cacheKey;
  }

  /// 缓存部分接口数据
  void cacheResponse(Response response) async {
    if (response.requestOptions.data != null &&
        (response.requestOptions.data is Map)) {
      Map map = response.requestOptions.data;
      if (map.containsKey('action')) {
        String action = map['action'];
        if (cacheList.contains(action)) {
          debugPrint('Cache save action $action.');
          String cacheKey = getCacheKey(response.requestOptions);
          debugPrint('Cache save key $cacheKey.');
          RespData respData = RespData(
            data: response.data,
            code: response.statusCode,
            message: response.statusMessage,
          );
          await Persistence.localStorage.setItem(cacheKey, respData);
          debugPrint(
              'Cache save succeeded. key $cacheKey, response $response.');
        }
      }
    }
  }

  /// 获取缓存
  Response? fetchCache(RequestOptions options) {
    if (options.data is Map) {
      Map map = options.data;
      if (map.containsKey('action')) {
        String action = map['action'];
        if (cacheList.contains(action)) {
          debugPrint('Cache fetch action $action.');
          String cacheKey = getCacheKey(options);
          debugPrint('Cache fetch cacheKey $cacheKey.');
          Map<String, dynamic>? cacheData =
              Persistence.localStorage.getItem(cacheKey);
          if (cacheData != null) {
            RespData respData = RespData.fromJson(cacheData);
            Response response = Response(
              requestOptions: options,
              statusCode: respData.code,
              statusMessage: respData.message,
              data: respData.data,
            );
            debugPrint(
                'Cache fetch succeeded. key $cacheKey, response $response.');
            return response;
          }
        }
      }
    }
    return null;
  }
}

class RespData {
  dynamic data;
  int? code;
  String? message;

  RespData({this.data, required this.code, required this.message});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['errcode'] = code;
    map['errmsg'] = message;
    map['data'] = data;
    return map;
  }

  RespData.fromJson(Map<String, dynamic> map) {
    code = map['code'];
    message = map['message'];
    data = map['data'];
  }

  bool get succeeded => actionOk == code;
}
