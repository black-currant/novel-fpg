const kIOSVer = 'ios_version'; // 苹果版本
const kAndroidVer = 'android_version'; // 安卓版本
const kCSCWeChat = 'csc_wechat'; // 客服联系-微信
const kCSCEmail = 'csc_email'; // 客服联系-邮箱
const kPrivacyPolicy = 'privacy_policy'; //
const kTermsOfService = 'service_terms'; //
const kForceUpdate = 'force_update'; //

/// 系统初始化配置
class InitialParams {
  late String name;
  late String option;

  InitialParams({required this.name, required this.option});

  InitialParams.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    option = json['option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['option'] = this.option;
    return data;
  }
}
