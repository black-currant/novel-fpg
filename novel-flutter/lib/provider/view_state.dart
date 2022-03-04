/// 页面状态类型
enum ViewState {
  idle, // 空闲的
  busy, //加载中
  empty, //无数据
  error, //加载失败
}

/// 错误类型
enum ViewStateErrorType {
  defaultError,
  networkTimeOutError, //网络错误
  unauthorizedError, //未授权(一般为未登录或者用户权限不足)
  insufficientBalanceError, //余额不足
}

class ViewStateError {
  ViewStateErrorType? errorType;
  String? message; // 界面显示的消息
  String error; // error.toString

  ViewStateError(this.errorType, {this.message, required this.error}) {
    errorType ??= ViewStateErrorType.defaultError;
    message ??= error;
  }

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  get isDefaultError => errorType == ViewStateErrorType.defaultError;

  get isNetworkTimeOut => errorType == ViewStateErrorType.networkTimeOutError;

  get isUnauthorized => errorType == ViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'ViewStateError{errorType: $errorType, message: $message, error: $error}';
  }
}

// enum ConnectivityStatus { WiFi, Cellular, Offline }
