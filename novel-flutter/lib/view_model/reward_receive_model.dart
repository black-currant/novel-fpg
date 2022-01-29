import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/foundation.dart';

/// 领取任务的奖励
class RewardReceiveModel extends ViewStateModel {
  final UserModel userModel;
  late int score;

  RewardReceiveModel({required this.userModel});

  // 发送请求
  Future<bool> request(String taskId) async {
    setBusy();

    try {
      Map<String, dynamic> data = await serverAPI.receiveReward(taskId);
      score = data['score'];
      debugPrint('Check in succeeded, score:' + score.toString());
      // 更新书币
      userModel.user.score = score;
      userModel.save(userModel.user);

      Future.delayed(const Duration(seconds: 1));

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
