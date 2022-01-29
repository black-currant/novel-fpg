import 'dart:io';

import 'package:novel_flutter/view_model/online_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 数据持久化
class Persistence {
  /// 键值对存储
  /// Android path '/data/data/$package/shared_prefs/FlutterSharedPreferences.xml'
  static late SharedPreferences sharedPreferences;

  /// 文件存储
  /// 临时目录
  /// e.g.: cookie
  static late Directory tempDir;

  /// APP文档目录
  /// Android path '/data/data/$package/app_flutter/'
  static late Directory appFilesDir;

  /// json字符串
  /// e.g.:
  /// Android path '/data/data/$package/app_flutter/novel2020'
  static late LocalStorage localStorage;

  /// 初始化操作，在应用启动时候调用
  static init() async {
    tempDir = await getTemporaryDirectory();
    appFilesDir = await getApplicationDocumentsDirectory();
    sharedPreferences = await SharedPreferences.getInstance();
    localStorage = LocalStorage('novel_flutter');
    await localStorage.ready;
    debugPrint('Local Storage initialized.');
    await check();
  }

  /// 检查本地保存的数据，如果非法则删除.
  static check() async {
    var loginedUsername =
        Persistence.sharedPreferences.getString(kLoginedUsername);
    var userId = Persistence.sharedPreferences.getInt(kUserId);
    if (loginedUsername == null && userId != null) {
      debugPrint('Storage check result is illegal.');
      try {
        await Persistence.localStorage.deleteItem(kUser);
        await Persistence.sharedPreferences.remove(kUserId);
        await Persistence.sharedPreferences.remove(kAccessToken);
      } catch (e) {}
    }
  }

  static Future<List<String>> printSharedPref() async {
    return sharedPreferences
        .getKeys()
        .map<String>((key) => '$key=${sharedPreferences.get(key)}')
        .toList();
  }
}
