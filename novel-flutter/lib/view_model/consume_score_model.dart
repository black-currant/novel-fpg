import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/app/server_api_throw.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';

/// 消耗书币，购买章节
class ConsumeScoreModel extends ViewStateModel {
  final UserModel userModel;

  ConsumeScoreModel(this.userModel);

  // 发送请求
  Future<bool> request(int chapterId, int bookId, int chapterPrice) async {
    assert(chapterPrice > 0);
    setBusy();
    try {
      if (userModel.user.score! < chapterPrice) {
        throw const InsufficientBalanceException();
      }
      Map<String, dynamic> data =
          await serverAPI.consumeScore(chapterId, bookId, chapterPrice);
      int score = data['score'];
      // 更新书币
      userModel.user.score = score;
      userModel.save(userModel.user);

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }
}
