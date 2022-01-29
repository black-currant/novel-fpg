import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/utils/device_util.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/utils/platform_util.dart';

/// 登录使用的参数
const String kLoginedUsername = 'loginedUsername';
const String kLoginedPassword = 'loginPassword';

/// 同步上线状态
class OnlineModel extends ViewStateModel {
  // 发送请求
  Future<bool> request(User param) async {
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
        param.account!,
        param.password,
        deviceId,
        deviceName,
        os,
        osVersion,
        appVersion,
        countryCode,
      );
      setIdle();
      return result != null;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
