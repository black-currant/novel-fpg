/// 任务的奖励
class Reward {
  int id;
  String name;
  String condition;
  bool issued; // 已经发放奖励
  String incentiveId; // 任务ID

  Reward(this.id, this.name, this.condition, this.issued, this.incentiveId);

  bool isIssued() => issued;
}
