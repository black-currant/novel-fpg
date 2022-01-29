import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/initial_params.dart';
import 'package:novel_flutter/provider/view_state_model.dart';

/// 初始化参数配置
class InitialModel extends ViewStateModel {
  Future<List<InitialParams>?> fetch() async {
    setBusy();
    try {
      var data = await serverAPI.initialParams();
      setIdle();
      return data;
    } catch (e, s) {
      setError(e, s);
      return null;
    }
  }
}
