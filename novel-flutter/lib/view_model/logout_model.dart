import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';

/// 登出帐号
class LogoutModel extends ViewStateModel {
  final UserModel userModel;

  LogoutModel(this.userModel);

  // 发送请求
  Future<bool> request() async {
    setBusy();
    try {
      await serverAPI.actionTrack('logout');
      // 清除本地缓存用户信息
      userModel.clear();

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
