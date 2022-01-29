class ScoreFlow {
  late int uid;
  late String remark;
  late int scoreAfter;
  late int score;
  late int id;
  late String createTime;
  late String sourceId;
  late int scoreBefore;

  ScoreFlow.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    remark = json['remark'];
    scoreAfter = json['score_after'];
    score = json['score'];
    id = json['id'];
    createTime = json['create_time'];
    sourceId = json['source_id'];
    scoreBefore = json['score_before'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['remark'] = this.remark;
    data['score_after'] = this.scoreAfter;
    data['score'] = this.score;
    data['id'] = this.id;
    data['create_time'] = this.createTime;
    data['source_id'] = this.sourceId;
    data['score_before'] = this.scoreBefore;
    return data;
  }
}
