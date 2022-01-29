import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/score_flow.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';

/// 书币流水列表
class ScoreFlowModel extends ViewStateRefreshListModel {
  ScoreFlowModel();

  @override
  Future<List<ScoreFlow>> loadData({required int pageNum}) async {
    return await serverAPI.scoreFlowList(pageIndex: pageNum);
  }
}
