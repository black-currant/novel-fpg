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
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnauthorizedException implements Exception {
  const UnauthorizedException();

  @override
  String toString() => 'UnauthorizedException';
}

/// 书币余额不足，需要跳转充值页面
class InsufficientBalanceException implements Exception {
  const InsufficientBalanceException();

  @override
  String toString() => 'InsufficientBalanceException';
}
