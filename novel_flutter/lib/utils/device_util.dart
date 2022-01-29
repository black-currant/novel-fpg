import 'dart:io';

import 'package:device_info/device_info.dart';

/// 设备信息工具
/// 依赖device_info库
class DeviceUtil {
  static Future getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      return await deviceInfo.androidInfo;
    } else if (Platform.isIOS) {
      return await deviceInfo.iosInfo;
    } else {
      return null;
    }
  }

  static Future<String> getDeviceId() async {
    String deviceId;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceId = androidInfo.androidId;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else {
      deviceId = '';
    }
    return deviceId;
  }

  /// 设备名
  /// Android: pixel-sailfish
  /// iOS:
  static Future<String> getDeviceName() async {
    String deviceName;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = '${androidInfo.model}-${androidInfo.product}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine;
    } else {
      deviceName = '';
    }
    return deviceName;
  }

  /// 打印
  static Future<String> print() async {
    var deviceId = 'deviceId:${await getDeviceId()}';
    var deviceName = 'deviceName:${await getDeviceName()}';
    var version = '';
    var info = '';
    DeviceInfoPlugin device = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await device.androidInfo;
      version =
          'baseOS:${androidInfo.version.baseOS},codename:${androidInfo.version.codename},incremental:${androidInfo.version.incremental},previewSdkInt:${androidInfo.version.previewSdkInt},release:${androidInfo.version.release},sdkInt:${androidInfo.version.sdkInt},securityPatch:${androidInfo.version.securityPatch}';
      info =
          'board:${androidInfo.board},bootloader:${androidInfo.bootloader},brand:${androidInfo.brand},device:${androidInfo.device},display:${androidInfo.display},fingerprint:${androidInfo.fingerprint},hardware:${androidInfo.hardware},host:${androidInfo.host},id:${androidInfo.id},manufacturer:${androidInfo.manufacturer},model:${androidInfo.model},product:${androidInfo.product},tags:${androidInfo.tags},type:${androidInfo.type},isPhysicalDevice:${androidInfo.isPhysicalDevice},androidId:${androidInfo.androidId},systemFeatures:${androidInfo.systemFeatures}';
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await device.iosInfo;
      version =
          'sysname:${iosInfo.utsname.sysname},nodename:${iosInfo.utsname.nodename},release:${iosInfo.utsname.release},version:${iosInfo.utsname.version},machine:${iosInfo.utsname.machine}';
      info =
          'name:${iosInfo.name},systemName:${iosInfo.systemName},systemVersion:${iosInfo.systemVersion},model:${iosInfo.model},localizedModel:${iosInfo.localizedModel},identifierForVendor:${iosInfo.identifierForVendor},isPhysicalDevice:${iosInfo.isPhysicalDevice}';
    }
    return 'Device info\n$deviceId\n$deviceName\n$version\n$info\n';
  }
}
