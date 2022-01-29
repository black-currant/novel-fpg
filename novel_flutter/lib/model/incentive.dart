import 'package:novel_flutter/model/reward.dart';

/// 用户激励任务
class Incentive {
  late String taskID;
  late String taskState;
  late String taskType;
  late String localeTitleDescription;
  late String param;
  late String virtualCurrency;
  late String actionName;
  late String note;
  late int status; // 任务状态
  late int progress; // 任务索引
  List<Reward> rewards = [];

  Incentive.fromJson(Map<String, dynamic> json) {
    taskID = json['Task ID'];
    taskState = json['Task State'];
    taskType = json['Task Type'];
    localeTitleDescription = json['Locale; Title; Description'];
    param = json['Param'];
    virtualCurrency = json['Virtual Currency'];
    actionName = json['Locale; Action Name'];
    note = json['Note'];
    status = json['status'];
    progress = json['progress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Task ID'] = this.taskID;
    data['Task State'] = this.taskState;
    data['Task Type'] = this.taskType;
    data['Locale; Title; Description'] = this.localeTitleDescription;
    data['Param'] = this.param;
    data['Virtual Currency'] = this.virtualCurrency;
    data['Action Name'] = this.actionName;
    data['Note'] = this.note;
    data['status'] = this.status;
    data['progress'] = this.progress;
    return data;
  }

  bool isCompleted() {
    return status == 1;
  }

  String getTitle(String languageTag) {
    try {
      List<String> temp = localeTitleDescription.split(';');
      if (languageTag.contains('zh-Hant')) {
        return temp[4];
      } else {
        return temp[1];
      }
    } catch (e) {
      return '';
    }
  }

  String getDescription(String languageTag) {
    try {
      List<String> temp = localeTitleDescription.split(';');
      if (languageTag.contains('zh-Hant')) {
        return temp[5];
      } else {
        return temp[2];
      }
    } catch (e) {
      return '';
    }
  }

  String getActionLabel(String languageTag) {
    try {
      List<String> temp = actionName.split(';');
      if (languageTag == 'zh-Hant') {
        return temp[3];
      } else {
        return temp[1];
      }
    } catch (e) {
      return '';
    }
  }
}
