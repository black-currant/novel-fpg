import 'dart:async';

import 'package:package_info/package_info.dart';

/// 包信息工具
/// 依赖package_info库
/// Android是APK
/// iOS是IPA
class PackageUtil {
  static Future<PackageInfo> getPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }

  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.packageName;
  }

  static Future<String> getAppName() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.appName;
  }

  static Future<int> getAppVersionCode() async {
    PackageInfo packageInfo = await getPackageInfo();
    return int.parse(packageInfo.buildNumber);
  }

  static Future<String> getAppVersionName() async {
    PackageInfo packageInfo = await getPackageInfo();
    return packageInfo.version;
  }
}
