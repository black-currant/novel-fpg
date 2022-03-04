import 'package:novel_flutter/app/http_interceptor.dart';

/// 接口操作失败的异常
class ActionFailedException implements Exception {
  int? code;
  String? message;

  ActionFailedException(this.code, this.message);

  ActionFailedException.fromRespData(RespData respData) {
    code = respData.code;
    message = respData.message;
  }

  @override
  String toString() {
    return 'errorCode=$code,errorMsg=$message';
  }
}

/// 书币余额不足，需要跳转充值页面
class InsufficientBalanceException implements Exception {
  const InsufficientBalanceException();

  @override
  String toString() => 'InsufficientBalanceException';
}
