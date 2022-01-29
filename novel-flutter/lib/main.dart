import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:novel_flutter/app/application.dart';
import 'package:novel_flutter/app/http_client.dart';
import 'package:novel_flutter/app/persistence.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化本地存储
  await Persistence.init();

  /// 控制日志打印
  if (kReleaseMode) {
    // 将debugPrint指定为空的执行体, 所以它什么也不做
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  /// 初始化HTTP实例
  await http.init();

  runApp(const MyApp());

  /// 设置系统状态栏透明色
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
  ));
}
