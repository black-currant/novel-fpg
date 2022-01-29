import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/http_interceptor.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/utils/device_util.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/utils/platform_util.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

// 使用[compute]函数在后台解码json
parseJson(String text) {
  devLog('parseJson $text');
  return compute(_parseAndDecode, text);
}

final http = Http();

/// HTTP客户端
/// 数据发送和接收
class Http extends DioForNative {
  /// 用户登录后刷新token
  void refreshToken() {
    var accessToken = Persistence.sharedPreferences.get(kAccessToken) ?? '';
    options.headers[accessTokenHeader] = accessToken;
    debugPrint('Dio headers ${options.headers}.');
  }

  Future init() async {
    options.baseUrl = devEnv ? devBaseUrl : produceBaseUrl; // 基础地址
    options.connectTimeout = 1000 * 30;
    options.receiveTimeout = 1000 * 30;
    // 头部信息
    var versionCode = await PackageUtil.getAppVersionCode();
    var versionName = await PackageUtil.getAppVersionName();
    var platformVersion = Platform.version;
    var operatingSystem = Platform.operatingSystem;
    var operatingSystemVersion = await PlatformUtil.getOperatingSystemVersion();
    var deviceId = await DeviceUtil.getDeviceId();
    var deviceName = await DeviceUtil.getDeviceName();
    var localeName = Platform.localeName;
    var userAgent =
        'V$versionName+$versionCode $platformVersion $operatingSystem+$operatingSystemVersion $deviceName+$deviceId';
    var accessToken = Persistence.sharedPreferences.get(kAccessToken) ?? '';
    Map<String, dynamic> headers = {
      HttpHeaders.acceptLanguageHeader: localeName,
      HttpHeaders.userAgentHeader: userAgent,
      accessTokenHeader: accessToken,
    };
    options.headers = headers; // 基础头部
    debugPrint('Dio headers ${options.headers}.');

    // 应用拦截器
    interceptors.add(MyInterceptor());

    // 缓存拦截器，本地有缓存则返回缓存，不发送远程请求，仅适用于请求方法“GET”。
//    dio.interceptors
//        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);

    // 日志拦截器
    if (devEnv) {
      interceptors.add(LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true));
    }

    /// 转换器的JSON解析，仅适用于请求方法“PUT”，“POST”和“PATCH”。
    /// 当jsonDecodeCallback为空时，Dio走json.decode
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;

    // 设置HTTP代理，用于抓包
    // flutter没有使用系统的代理
    var localhost = '';
    if (devEnv && localhost.isNotEmpty) {
      var proxy = 'PROXY $localhost';
      debugPrint('Set proxy $proxy');
      (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return Platform.isAndroid;
        };
        // config the http client
        client.findProxy = (uri) {
          // proxy all request to localhost:8888
          return proxy;
        };
        // you can also create a HttpClient to dio
        // return HttpClient();
      };
    }

    debugPrint('Http instance initialized.');
  }
}

// Dio的请求流：发起请求 >> 请求拦截器 >> 请求转换器 >> 发起请求 >> 响应转换器 >> 响应拦截器 >> 最终结果
// 多个拦截器的顺序，发起请求 >> 请求拦截器1 >> 请求拦截器2 >> ... >>响应拦截器1 >> 响应拦截器2 >> 最终结果
// Dio 使用DefaultHttpClientAdapter作为其默认HttpClientAdapter，DefaultHttpClientAdapter使用dart:io:HttpClient 来发起网络请求。
