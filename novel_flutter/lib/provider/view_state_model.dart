import 'dart:io';

import 'package:novel_flutter/app/server_api_throw.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'view_state.dart';

class ViewStateModel with ChangeNotifier {
  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  /// 当前的页面状态,默认为busy,可在viewModel的构造方法中指定;
  ViewState _viewState;

  /// 根据状态构造
  ///
  /// 子类可以在构造函数指定需要的页面状态
  /// FooModel():super(viewState:ViewState.busy);
  ///
  /// ProviderWidget的onModelReady执行顺序问题，以及setState() or markNeedsBuild() called during build.错误
  ViewStateModel({ViewState? viewState})
      : _viewState = viewState ?? ViewState.idle {
    debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  /// ViewState
  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }

  set viewStateNotNotify(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
  }

  /// ViewStateError
  ViewStateError? _viewStateError;

  ViewStateError? get viewStateError => _viewStateError;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  ///
  /// get
  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy({bool duringBuild = false}) {
    if (duringBuild) {
      viewStateNotNotify = ViewState.busy;
    } else {
      viewState = ViewState.busy;
    }
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  /// [exception]分类Error和Exception两种？
  /// [stackTrace]堆栈追踪
  /// [message]界面显示的消息
  void setError(exception, stackTrace, {String? message}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;
    if (exception is DioError) {
      DioError dioError = exception;
      if (dioError.type == DioErrorType.connectTimeout ||
          dioError.type == DioErrorType.sendTimeout ||
          dioError.type == DioErrorType.receiveTimeout) {
        // timeout
        errorType = ViewStateErrorType.networkTimeOutError;
      } else if (dioError.type == DioErrorType.response) {
        // incorrect status, such as 404, 503...
        message = dioError.error;
      } else if (dioError.type == DioErrorType.cancel) {
        // to be continue...
        message = dioError.error;
      } else {
        // 以下都是DioErrorType.DEFAULT
        // dio将原error重新套了一层
        dynamic error = dioError.error;
        if (error is UnauthorizedException) {
          errorType = ViewStateErrorType.unauthorizedError;
        }
        // else if (error is EmailVerifiedException) {
        //   errorType = ViewStateErrorType.emailVerifiedError;
        // }
        else if (error is ActionFailedException) {
          message = error.message;
        } else if (error is SocketException || error is HandshakeException) {
          errorType = ViewStateErrorType.networkTimeOutError;
        } else if (error is String) {
          message = error;
        } else {
          message = error.toString();
        }
      }
    }

    viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      error: '$exception',
    );
    printErrorStack(exception, stackTrace);
    onError(viewStateError!);
  }

  void onError(ViewStateError viewStateError) {}

  /// 显示错误消息
  showErrorMessage(context, {String? message}) {
    if (viewStateError != null || message != null) {
      if (viewStateError!.isNetworkTimeOut) {
        message ??= S.of(context).viewStateMessageNetworkError;
      } else {
        message ??= viewStateError!.message;
      }
      Future.microtask(() {
        showToast(message!, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'BaseModel{_viewState: $viewState, _viewStateError: $_viewStateError}';
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    debugPrint('ViewStateModel dispose -->$runtimeType');
    super.dispose();
  }
}

/// [e]为错误类型 :可能为 Error, Exception, String
/// [s]为堆栈信息
printErrorStack(e, s) {
  print('\ne=$e');
  if (s != null) print('\ntrace=$s');
}
