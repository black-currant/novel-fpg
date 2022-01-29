import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/utils/device_util.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/utils/platform_util.dart';
import 'package:novel_flutter/view_model/user_model.dart';

/// 用户登录
class SignInViewModel extends ViewStateModel {
  final UserModel userModel;

  SignInViewModel({required this.userModel});

  Future<bool> login(username, password) async {
    setBusy();
    try {
      String deviceId = await DeviceUtil.getDeviceId();
      String deviceName = await DeviceUtil.getDeviceName();
      String os = PlatformUtil.getOperatingSystem();
      String osVersion = await PlatformUtil.getOperatingSystemVersion();
      int versionCode = await PackageUtil.getAppVersionCode();
      String versionName = await PackageUtil.getAppVersionName();
      String appVersion = '$versionName+$versionCode';
      String countryCode = PlatformUtil.getCountryCode();
      User? result = await serverAPI.login(
        username,
        password,
        deviceId,
        deviceName,
        os,
        osVersion,
        appVersion,
        countryCode,
      );
      result!.emailVerified = false;
      // 本地保存用户信息
      userModel.save(result);

      setIdle();
      return true;
    } catch (exception, stackTrace) {
      print('$exceptionCaughtBySelf: $exception ${exception.runtimeType}');
      print('$stackTraceTag: $stackTrace ${stackTrace.runtimeType}');
      setError(exception, stackTrace);
      return false;
    }
  }
}
