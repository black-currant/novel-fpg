import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';

/// 上报阅读时长
class ReadingTimeReportModel extends ViewStateModel {
  final UserModel userModel;

  ReadingTimeReportModel(this.userModel);

  // 发送请求
  Future<bool> request(int bookId, int duration) async {
    setBusy();
    try {
      Map<String, dynamic> data =
          await serverAPI.readingTimeReport(bookId, duration);
      int score = data['score'];
      int readingTime = data['duration'];
      // 更新缓存
      userModel.user.score = score;
      userModel.user.duration = readingTime;
      userModel.save(userModel.user);

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
