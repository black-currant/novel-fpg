/// 用户信息实体类
class User {
  String? account;
  String? appVersion;
  String? country;
  String? deviceMode;
  String? deviceid;
  int? duration;
  String? email;
  String? gender;
  int? id;
  String? logip;
  String? logtime;
  int? mainId;
  String? nickname;
  String? os;
  String? osVersion;
  String? phone;
  String? photourl;
  String? pid;
  int? preference;
  String? provider;
  int? register;
  int? score;
  int? status;
  String? token;
  int? vip;
  int? viptime;

  // 额外字段
  late String fbid;
  late bool emailVerified;
  late String password;

  User(
      {this.account,
      this.appVersion,
      this.country,
      this.deviceMode,
      this.deviceid,
      this.duration,
      this.email,
      this.gender,
      this.id,
      this.logip,
      this.logtime,
      this.mainId,
      this.nickname,
      this.os,
      this.osVersion,
      this.phone,
      this.photourl,
      this.pid,
      this.preference,
      this.provider,
      this.register,
      this.score,
      this.status,
      this.token,
      this.vip,
      this.viptime});

  User.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    appVersion = json['app_version'];
    country = json['country'];
    deviceMode = json['device_mode'];
    deviceid = json['deviceid'];
    duration = json['duration'];
    email = json['email'];
    gender = json['gender'];
    id = json['id'];
    logip = json['logip'];
    logtime = json['logtime'];
    mainId = json['main_id'];
    nickname = json['nickname'];
    os = json['os'];
    osVersion = json['os_version'];
    phone = json['phone'];
    photourl = json['photourl'];
    pid = json['pid'];
    preference = json['preference'];
    provider = json['provider'];
    register = json['register'];
    score = json['score'];
    status = json['status'];
    token = json['token'];
    vip = json['vip'];
    viptime = json['viptime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['account'] = this.account;
    data['app_version'] = this.appVersion;
    data['country'] = this.country;
    data['device_mode'] = this.deviceMode;
    data['deviceid'] = this.deviceid;
    data['duration'] = this.duration;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['id'] = this.id;
    data['logip'] = this.logip;
    data['logtime'] = this.logtime;
    data['main_id'] = this.mainId;
    data['nickname'] = this.nickname;
    data['os'] = this.os;
    data['os_version'] = this.osVersion;
    data['phone'] = this.phone;
    data['photourl'] = this.photourl;
    data['pid'] = this.pid;
    data['preference'] = this.preference;
    data['provider'] = this.provider;
    data['register'] = this.register;
    data['score'] = this.score;
    data['status'] = this.status;
    data['token'] = this.token;
    data['vip'] = this.vip;
    data['viptime'] = this.viptime;
    return data;
  }
}
