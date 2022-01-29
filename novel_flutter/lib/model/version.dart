/// APP版本信息
class Version {
  late int versionCode;
  late String versionName;
  late String desc;
  late int forced;
  late String downloadUrl;

  Version(
      {required this.versionCode,
      required this.versionName,
      required this.desc,
      required this.forced,
      required this.downloadUrl});

  Version.fromJson(Map<String, dynamic> json) {
    versionCode = json['versionCode'];
    versionName = json['versionName'];
    desc = json['desc'];
    forced = json['forced'];
    downloadUrl = json['downloadUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['versionCode'] = this.versionCode;
    data['versionName'] = this.versionName;
    data['desc'] = this.desc;
    data['forced'] = this.forced;
    data['downloadUrl'] = this.downloadUrl;
    return data;
  }

  bool get isForced => forced == 1;
}
