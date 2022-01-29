import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/version.dart';
import 'package:novel_flutter/provider/view_state_model.dart';

/// APP升级
class UpgradeModel extends ViewStateModel {
  Future<Version?> request() async {
    setBusy();
    try {
      Version data = await serverAPI.upgrade();
      setIdle();
      return data;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }
}
