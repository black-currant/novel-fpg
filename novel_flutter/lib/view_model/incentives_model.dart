import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/model/reward.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';

/// 用户激励任务列表
class IncentivesModel extends ViewStateRefreshListModel<Incentive> {
  /// 签到
  Incentive? _checkIn;

  /// 阅读
  final List<Incentive> _reading = [];

  /// 新手
  final List<Incentive> _newbie = [];

  /// 每日
  final List<Incentive> _daily = [];

  @override
  Future<List<Incentive>> loadData({required int pageNum}) async {
    if (pageNum > ViewStateRefreshListModel.pageNumFirst) {
      return [];
    }

    List<Incentive> data = await serverAPI.incentives();
    if (data.isEmpty) return [];

    /// 如果已经是微信或者脸书登录，则移除此任务，或者修改状态。
    // if (userModel.hasUser) {
    //   data.removeWhere((item) {
    //     if (item.taskID == taskIdBindFacebook) {
    //       return userModel.user.provider == 'facebook.com';
    //     } else if (item.taskID == taskIdBindWeChat) {
    //       return userModel.user.provider == 'wechat.com';
    //     } else {
    //       return false;
    //     }
    //   });
    // }

    _checkIn = null;
    _reading.clear();
    _newbie.clear();
    _daily.clear();

    for (var item in data) {
      if (item.taskID == taskIdCheckIn) {
        _checkIn = item;
        // 构建签到奖励数据
        _checkIn!.rewards = generateRewards(item);
      } else if (item.taskType == 'reading') {
        _reading.add(item);
      } else if (item.taskID == taskIdReadingTime) {
        // 构建阅读时长奖励数据
        item.rewards = generateRewards(item);
        _reading.add(item);
      } else if (item.taskType == 'newbie') {
        _newbie.add(item);
      } else if (item.taskType == 'daily') {
        _daily.add(item);
      }
    }

    return data;
  }

  List<Reward> generateRewards(Incentive item) {
    List<Reward> rewards = [];
    // 构建签到奖励数据
    var name = item.virtualCurrency.split('|');
    var label = item.param.split('|');
    var index = item.progress;
    var completed = item.isCompleted();
    for (var i = 0; i < name.length; i++) {
      bool issued = false;
      if (index > i) {
        issued = true;
      } else if (index == i && completed) {
        issued = true;
      } else {
        issued = false;
      }
      rewards.add(Reward(0, name[i], label[i], issued, item.taskID));
    }
    return rewards;
  }

  Incentive? get checkIn => _checkIn;

  set checkIn(Incentive? value) {
    if (value != null) {
      _checkIn = value;
      notifyListeners();
    }
  }

  bool get checkInCompleted =>
      _checkIn == null ? false : _checkIn!.isCompleted();

  List<Incentive> get reading => _reading;

  List<Incentive> get newbie => _newbie;

  List<Incentive> get daily => _daily;
}
