import 'dart:io';

import 'package:device_info/device_info.dart';

/// 系统平台工具
class PlatformUtil {
  /// 获取国家代码
  static getCountryCode() {
    var result = Platform.localeName.split('_'); // zh_Hans_CN;en_HK;en_US
    return result[result.length - 1];
  }

  /// 获取平台系统
  static getOperatingSystem() {
    String label;
    if (Platform.isAndroid) {
      label = 'Android';
    } else if (Platform.isIOS) {
      label = 'iOS';
    } else {
      label = Platform.operatingSystem;
    }
    return label;
  }

  /// 系统版本
  static Future<String> getOperatingSystemVersion() async {
    String version;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      version = '${androidInfo.version.sdkInt}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      version = iosInfo.systemVersion;
    } else {
      version = '';
    }
    return version;
  }

  static Future<String> print() async {
    var base =
        'platformVersion:${Platform.version},operatingSystem:${Platform.operatingSystem},operatingSystemVersion:${Platform.operatingSystemVersion},pathSeparator:${Platform.pathSeparator},localeName:${Platform.localeName},packageConfig:${Platform.packageConfig}';
    var extra =
        'getOperatingSystemVersion:${await PlatformUtil.getOperatingSystemVersion()}';
    return 'Platform info\n$base\n$extra\n';
  }
}
