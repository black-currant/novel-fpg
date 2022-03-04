// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `正在连接PlayStore`
  String get loadGooglePlay {
    return Intl.message(
      '正在连接PlayStore',
      name: 'loadGooglePlay',
      desc: '',
      args: [],
    );
  }

  /// `输入用户名`
  String get usernameHint {
    return Intl.message(
      '输入用户名',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `输入密码`
  String get passwordHint {
    return Intl.message(
      '输入密码',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `正在连接AppStore`
  String get loadAppStore {
    return Intl.message(
      '正在连接AppStore',
      name: 'loadAppStore',
      desc: '',
      args: [],
    );
  }

  /// `查看订单`
  String get checkOrder {
    return Intl.message(
      '查看订单',
      name: 'checkOrder',
      desc: '',
      args: [],
    );
  }

  /// `开源许可`
  String get openSourceLicense {
    return Intl.message(
      '开源许可',
      name: 'openSourceLicense',
      desc: '',
      args: [],
    );
  }

  /// `保密`
  String get keepSecret {
    return Intl.message(
      '保密',
      name: 'keepSecret',
      desc: '',
      args: [],
    );
  }

  /// `跳转到商店更新`
  String get jumpToUpdateInStore {
    return Intl.message(
      '跳转到商店更新',
      name: 'jumpToUpdateInStore',
      desc: '',
      args: [],
    );
  }

  /// `正在读取内容，请稍等...`
  String get loadChapterContent {
    return Intl.message(
      '正在读取内容，请稍等...',
      name: 'loadChapterContent',
      desc: '',
      args: [],
    );
  }

  /// `购买失败`
  String get failedPurchase {
    return Intl.message(
      '购买失败',
      name: 'failedPurchase',
      desc: '',
      args: [],
    );
  }

  /// `正在购买章节...`
  String get purchasingChapter {
    return Intl.message(
      '正在购买章节...',
      name: 'purchasingChapter',
      desc: '',
      args: [],
    );
  }

  /// `用户ID`
  String get userID {
    return Intl.message(
      '用户ID',
      name: 'userID',
      desc: '',
      args: [],
    );
  }

  /// `授权失败`
  String get authFailed {
    return Intl.message(
      '授权失败',
      name: 'authFailed',
      desc: '',
      args: [],
    );
  }

  /// `授权取消`
  String get authCancelled {
    return Intl.message(
      '授权取消',
      name: 'authCancelled',
      desc: '',
      args: [],
    );
  }

  /// `授权中`
  String get authorizing {
    return Intl.message(
      '授权中',
      name: 'authorizing',
      desc: '',
      args: [],
    );
  }

  /// `没有帐号？去注册`
  String get gotoSignUp {
    return Intl.message(
      '没有帐号？去注册',
      name: 'gotoSignUp',
      desc: '',
      args: [],
    );
  }

  /// `密码错误`
  String get wrongPassword {
    return Intl.message(
      '密码错误',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `登录失败`
  String get signInFailed {
    return Intl.message(
      '登录失败',
      name: 'signInFailed',
      desc: '',
      args: [],
    );
  }

  /// `登录成功`
  String get signInSucceeded {
    return Intl.message(
      '登录成功',
      name: 'signInSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `确认密码`
  String get confirmPassword {
    return Intl.message(
      '确认密码',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `再次输入密码`
  String get reTypePasswordHint {
    return Intl.message(
      '再次输入密码',
      name: 'reTypePasswordHint',
      desc: '',
      args: [],
    );
  }

  /// `两次密码不一致`
  String get twoPwdDifferent {
    return Intl.message(
      '两次密码不一致',
      name: 'twoPwdDifferent',
      desc: '',
      args: [],
    );
  }

  /// `登录`
  String get signIn {
    return Intl.message(
      '登录',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `注册`
  String get signUp {
    return Intl.message(
      '注册',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `确定退出帐号？`
  String get areYouSureToLogout {
    return Intl.message(
      '确定退出帐号？',
      name: 'areYouSureToLogout',
      desc: '',
      args: [],
    );
  }

  /// `您尚未设置昵称`
  String get notSetNickname {
    return Intl.message(
      '您尚未设置昵称',
      name: 'notSetNickname',
      desc: '',
      args: [],
    );
  }

  /// `已签到{dayCount}天，继续加油`
  String checkInProgress(Object dayCount) {
    return Intl.message(
      '已签到$dayCount天，继续加油',
      name: 'checkInProgress',
      desc: '',
      args: [dayCount],
    );
  }

  /// `注册表明您同意`
  String get userAgreementPrefixLabel {
    return Intl.message(
      '注册表明您同意',
      name: 'userAgreementPrefixLabel',
      desc: '',
      args: [],
    );
  }

  /// `获取商品`
  String get fetchingProducts {
    return Intl.message(
      '获取商品',
      name: 'fetchingProducts',
      desc: '',
      args: [],
    );
  }

  /// `已经复制到剪切板`
  String get copy2Clipboard {
    return Intl.message(
      '已经复制到剪切板',
      name: 'copy2Clipboard',
      desc: '',
      args: [],
    );
  }

  /// `浅色模式`
  String get lightModel {
    return Intl.message(
      '浅色模式',
      name: 'lightModel',
      desc: '',
      args: [],
    );
  }

  /// `深色模式`
  String get darkModel {
    return Intl.message(
      '深色模式',
      name: 'darkModel',
      desc: '',
      args: [],
    );
  }

  /// `外观`
  String get skin {
    return Intl.message(
      '外观',
      name: 'skin',
      desc: '',
      args: [],
    );
  }

  /// `建议您注册或登录，使您能够从其任何{platform}设备访问内容。`
  String notYetLoginMsg(Object platform) {
    return Intl.message(
      '建议您注册或登录，使您能够从其任何$platform设备访问内容。',
      name: 'notYetLoginMsg',
      desc: '',
      args: [platform],
    );
  }

  /// `阅读器`
  String get reader {
    return Intl.message(
      '阅读器',
      name: 'reader',
      desc: '',
      args: [],
    );
  }

  /// `购买成功`
  String get purchaseSucceeded {
    return Intl.message(
      '购买成功',
      name: 'purchaseSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `自动购买下一章节`
  String get automaticRenewal {
    return Intl.message(
      '自动购买下一章节',
      name: 'automaticRenewal',
      desc: '',
      args: [],
    );
  }

  /// `购买本章，继续阅读`
  String get gotoPurchase {
    return Intl.message(
      '购买本章，继续阅读',
      name: 'gotoPurchase',
      desc: '',
      args: [],
    );
  }

  /// `书币余额不足`
  String get insufficientBalance {
    return Intl.message(
      '书币余额不足',
      name: 'insufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `本章价格`
  String get chapterPrice {
    return Intl.message(
      '本章价格',
      name: 'chapterPrice',
      desc: '',
      args: [],
    );
  }

  /// `购买章节`
  String get purchaseChapter {
    return Intl.message(
      '购买章节',
      name: 'purchaseChapter',
      desc: '',
      args: [],
    );
  }

  /// `充值书币`
  String get purchaseVirtualCurrency {
    return Intl.message(
      '充值书币',
      name: 'purchaseVirtualCurrency',
      desc: '',
      args: [],
    );
  }

  /// `充值金额（$1=100书币）`
  String get exchangeRate {
    return Intl.message(
      '充值金额（\$1=100书币）',
      name: 'exchangeRate',
      desc: '',
      args: [],
    );
  }

  /// `您有订单尚未支付`
  String get orderWaitPayTitle {
    return Intl.message(
      '您有订单尚未支付',
      name: 'orderWaitPayTitle',
      desc: '',
      args: [],
    );
  }

  /// `订单待支付`
  String get orderWaitPay {
    return Intl.message(
      '订单待支付',
      name: 'orderWaitPay',
      desc: '',
      args: [],
    );
  }

  /// `订单结束`
  String get orderFinished {
    return Intl.message(
      '订单结束',
      name: 'orderFinished',
      desc: '',
      args: [],
    );
  }

  /// `书名/作者`
  String get searchHint {
    return Intl.message(
      '书名/作者',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `行间距`
  String get lineSpacing {
    return Intl.message(
      '行间距',
      name: 'lineSpacing',
      desc: '',
      args: [],
    );
  }

  /// `默认`
  String get default_ {
    return Intl.message(
      '默认',
      name: 'default_',
      desc: '',
      args: [],
    );
  }

  /// `阅读时不自动锁屏`
  String get readerWakeLock {
    return Intl.message(
      '阅读时不自动锁屏',
      name: 'readerWakeLock',
      desc: '',
      args: [],
    );
  }

  /// `阅读设置`
  String get readerPrefs {
    return Intl.message(
      '阅读设置',
      name: 'readerPrefs',
      desc: '',
      args: [],
    );
  }

  /// `白天`
  String get daytime {
    return Intl.message(
      '白天',
      name: 'daytime',
      desc: '',
      args: [],
    );
  }

  /// `夜间`
  String get night {
    return Intl.message(
      '夜间',
      name: 'night',
      desc: '',
      args: [],
    );
  }

  /// `上一章`
  String get previousChapter {
    return Intl.message(
      '上一章',
      name: 'previousChapter',
      desc: '',
      args: [],
    );
  }

  /// `下一章`
  String get nextChapter {
    return Intl.message(
      '下一章',
      name: 'nextChapter',
      desc: '',
      args: [],
    );
  }

  /// `已经是最后一页`
  String get isBookFooter {
    return Intl.message(
      '已经是最后一页',
      name: 'isBookFooter',
      desc: '',
      args: [],
    );
  }

  /// `已经是第一页`
  String get isBookHeader {
    return Intl.message(
      '已经是第一页',
      name: 'isBookHeader',
      desc: '',
      args: [],
    );
  }

  /// `页`
  String get page {
    return Intl.message(
      '页',
      name: 'page',
      desc: '',
      args: [],
    );
  }

  /// `第`
  String get num {
    return Intl.message(
      '第',
      name: 'num',
      desc: '',
      args: [],
    );
  }

  /// `性别`
  String get gender {
    return Intl.message(
      '性别',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `昵称`
  String get nickname {
    return Intl.message(
      '昵称',
      name: 'nickname',
      desc: '',
      args: [],
    );
  }

  /// `头像`
  String get avatar {
    return Intl.message(
      '头像',
      name: 'avatar',
      desc: '',
      args: [],
    );
  }

  /// `头像更换失败`
  String get avatarEditFailed {
    return Intl.message(
      '头像更换失败',
      name: 'avatarEditFailed',
      desc: '',
      args: [],
    );
  }

  /// `头像更换成功`
  String get avatarUpdated {
    return Intl.message(
      '头像更换成功',
      name: 'avatarUpdated',
      desc: '',
      args: [],
    );
  }

  /// `处理中`
  String get processing {
    return Intl.message(
      '处理中',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `未知`
  String get unknown {
    return Intl.message(
      '未知',
      name: 'unknown',
      desc: '',
      args: [],
    );
  }

  /// `请输入内容`
  String get pleaseTypeContent {
    return Intl.message(
      '请输入内容',
      name: 'pleaseTypeContent',
      desc: '',
      args: [],
    );
  }

  /// `编辑昵称`
  String get editNickname {
    return Intl.message(
      '编辑昵称',
      name: 'editNickname',
      desc: '',
      args: [],
    );
  }

  /// `编辑性别`
  String get editGender {
    return Intl.message(
      '编辑性别',
      name: 'editGender',
      desc: '',
      args: [],
    );
  }

  /// `完成`
  String get done {
    return Intl.message(
      '完成',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `修改成功，将为你重新推荐书籍`
  String get changeSuccessfulAndBookTypePrefs {
    return Intl.message(
      '修改成功，将为你重新推荐书籍',
      name: 'changeSuccessfulAndBookTypePrefs',
      desc: '',
      args: [],
    );
  }

  /// `相册`
  String get photoAlbum {
    return Intl.message(
      '相册',
      name: 'photoAlbum',
      desc: '',
      args: [],
    );
  }

  /// `拍照`
  String get takePicture {
    return Intl.message(
      '拍照',
      name: 'takePicture',
      desc: '',
      args: [],
    );
  }

  /// `进入书城`
  String get enterTheApplication {
    return Intl.message(
      '进入书城',
      name: 'enterTheApplication',
      desc: '',
      args: [],
    );
  }

  /// `根据阅读喜好\n个性化推荐书籍`
  String get bookTypePrefsSlogan {
    return Intl.message(
      '根据阅读喜好\n个性化推荐书籍',
      name: 'bookTypePrefsSlogan',
      desc: '',
      args: [],
    );
  }

  /// `已完结`
  String get bookEnd {
    return Intl.message(
      '已完结',
      name: 'bookEnd',
      desc: '',
      args: [],
    );
  }

  /// `连载中`
  String get bookSerial {
    return Intl.message(
      '连载中',
      name: 'bookSerial',
      desc: '',
      args: [],
    );
  }

  /// `万字`
  String get millionWords {
    return Intl.message(
      '万字',
      name: 'millionWords',
      desc: '',
      args: [],
    );
  }

  /// `字`
  String get word {
    return Intl.message(
      '字',
      name: 'word',
      desc: '',
      args: [],
    );
  }

  /// `书币余额`
  String get balance {
    return Intl.message(
      '书币余额',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `书币流水`
  String get incomeAndExpenditure {
    return Intl.message(
      '书币流水',
      name: 'incomeAndExpenditure',
      desc: '',
      args: [],
    );
  }

  /// `退出登录`
  String get logout {
    return Intl.message(
      '退出登录',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `个人信息`
  String get userProfile {
    return Intl.message(
      '个人信息',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `通知`
  String get notifications {
    return Intl.message(
      '通知',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `软体不错赞一个`
  String get review {
    return Intl.message(
      '软体不错赞一个',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `阅读喜好`
  String get bookTypePrefs {
    return Intl.message(
      '阅读喜好',
      name: 'bookTypePrefs',
      desc: '',
      args: [],
    );
  }

  /// `我的订单`
  String get myOrder {
    return Intl.message(
      '我的订单',
      name: 'myOrder',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get prefs {
    return Intl.message(
      '设置',
      name: 'prefs',
      desc: '',
      args: [],
    );
  }

  /// `常见问题`
  String get faq {
    return Intl.message(
      '常见问题',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `反馈意见`
  String get feedback {
    return Intl.message(
      '反馈意见',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `帮助`
  String get help {
    return Intl.message(
      '帮助',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `帮助与反馈`
  String get helpAndFeedback {
    return Intl.message(
      '帮助与反馈',
      name: 'helpAndFeedback',
      desc: '',
      args: [],
    );
  }

  /// `通用`
  String get general {
    return Intl.message(
      '通用',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `未找到邮件客户端`
  String get mailClientNotFound {
    return Intl.message(
      '未找到邮件客户端',
      name: 'mailClientNotFound',
      desc: '',
      args: [],
    );
  }

  /// `电子邮箱`
  String get email {
    return Intl.message(
      '电子邮箱',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `客服中心`
  String get customerService {
    return Intl.message(
      '客服中心',
      name: 'customerService',
      desc: '',
      args: [],
    );
  }

  /// `微信`
  String get weChat {
    return Intl.message(
      '微信',
      name: 'weChat',
      desc: '',
      args: [],
    );
  }

  /// `帐号与安全`
  String get accountSecurity {
    return Intl.message(
      '帐号与安全',
      name: 'accountSecurity',
      desc: '',
      args: [],
    );
  }

  /// `请确认密码`
  String get pleaseConfirmPassword {
    return Intl.message(
      '请确认密码',
      name: 'pleaseConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入密码`
  String get pleaseTypePassword {
    return Intl.message(
      '请输入密码',
      name: 'pleaseTypePassword',
      desc: '',
      args: [],
    );
  }

  /// `请输入帐号`
  String get pleaseTypeAccount {
    return Intl.message(
      '请输入帐号',
      name: 'pleaseTypeAccount',
      desc: '',
      args: [],
    );
  }

  /// `和`
  String get and {
    return Intl.message(
      '和',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `我已阅读并同意`
  String get iHaveReadAndAgree {
    return Intl.message(
      '我已阅读并同意',
      name: 'iHaveReadAndAgree',
      desc: '',
      args: [],
    );
  }

  /// `阅读福利`
  String get readingIncentive {
    return Intl.message(
      '阅读福利',
      name: 'readingIncentive',
      desc: '',
      args: [],
    );
  }

  /// `新手福利`
  String get newbieIncentive {
    return Intl.message(
      '新手福利',
      name: 'newbieIncentive',
      desc: '',
      args: [],
    );
  }

  /// `已完成`
  String get completed {
    return Intl.message(
      '已完成',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `已签到`
  String get checkInAlready {
    return Intl.message(
      '已签到',
      name: 'checkInAlready',
      desc: '',
      args: [],
    );
  }

  /// `签到`
  String get checkInAction {
    return Intl.message(
      '签到',
      name: 'checkInAction',
      desc: '',
      args: [],
    );
  }

  /// `福利中心`
  String get welfareCenter {
    return Intl.message(
      '福利中心',
      name: 'welfareCenter',
      desc: '',
      args: [],
    );
  }

  /// `日常福利`
  String get dailyWelfare {
    return Intl.message(
      '日常福利',
      name: 'dailyWelfare',
      desc: '',
      args: [],
    );
  }

  /// `签到成功，奖励`
  String get checkInSucceeded {
    return Intl.message(
      '签到成功，奖励',
      name: 'checkInSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `天签到领取福利`
  String get checkInSlogan {
    return Intl.message(
      '天签到领取福利',
      name: 'checkInSlogan',
      desc: '',
      args: [],
    );
  }

  /// `支付`
  String get payment {
    return Intl.message(
      '支付',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `书币`
  String get virtualCurrency {
    return Intl.message(
      '书币',
      name: 'virtualCurrency',
      desc: '',
      args: [],
    );
  }

  /// `签到规则`
  String get checkInRule {
    return Intl.message(
      '签到规则',
      name: 'checkInRule',
      desc: '',
      args: [],
    );
  }

  /// `规则`
  String get rule {
    return Intl.message(
      '规则',
      name: 'rule',
      desc: '',
      args: [],
    );
  }

  /// `天`
  String get day {
    return Intl.message(
      '天',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `您已经连续签到`
  String get checkInMessage {
    return Intl.message(
      '您已经连续签到',
      name: 'checkInMessage',
      desc: '',
      args: [],
    );
  }

  /// `本`
  String get bookUnit {
    return Intl.message(
      '本',
      name: 'bookUnit',
      desc: '',
      args: [],
    );
  }

  /// `同类精品`
  String get sameType {
    return Intl.message(
      '同类精品',
      name: 'sameType',
      desc: '',
      args: [],
    );
  }

  /// `猜你喜欢`
  String get maybeLike {
    return Intl.message(
      '猜你喜欢',
      name: 'maybeLike',
      desc: '',
      args: [],
    );
  }

  /// `换一批`
  String get changeBatch {
    return Intl.message(
      '换一批',
      name: 'changeBatch',
      desc: '',
      args: [],
    );
  }

  /// `主编力推`
  String get editorChoice {
    return Intl.message(
      '主编力推',
      name: 'editorChoice',
      desc: '',
      args: [],
    );
  }

  /// `每日精选`
  String get dailyPicks {
    return Intl.message(
      '每日精选',
      name: 'dailyPicks',
      desc: '',
      args: [],
    );
  }

  /// `确定将选中的{bookCount}本书籍移出书架?`
  String removeBookMsg(Object bookCount) {
    return Intl.message(
      '确定将选中的$bookCount本书籍移出书架?',
      name: 'removeBookMsg',
      desc: '',
      args: [bookCount],
    );
  }

  /// `提示`
  String get alter {
    return Intl.message(
      '提示',
      name: 'alter',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `全选`
  String get selectAll {
    return Intl.message(
      '全选',
      name: 'selectAll',
      desc: '',
      args: [],
    );
  }

  /// `全不选`
  String get unSelectAll {
    return Intl.message(
      '全不选',
      name: 'unSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `推荐`
  String get recommend {
    return Intl.message(
      '推荐',
      name: 'recommend',
      desc: '',
      args: [],
    );
  }

  /// `继续阅读`
  String get continueReading {
    return Intl.message(
      '继续阅读',
      name: 'continueReading',
      desc: '',
      args: [],
    );
  }

  /// `签到`
  String get checkIn {
    return Intl.message(
      '签到',
      name: 'checkIn',
      desc: '',
      args: [],
    );
  }

  /// `福利不间断，免费金币天天领`
  String get incentiveSlogan {
    return Intl.message(
      '福利不间断，免费金币天天领',
      name: 'incentiveSlogan',
      desc: '',
      args: [],
    );
  }

  /// `编辑`
  String get edit {
    return Intl.message(
      '编辑',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `分钟`
  String get minutes {
    return Intl.message(
      '分钟',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `本周已阅读`
  String get thisWeekRead {
    return Intl.message(
      '本周已阅读',
      name: 'thisWeekRead',
      desc: '',
      args: [],
    );
  }

  /// `操作失败`
  String get operationFailed {
    return Intl.message(
      '操作失败',
      name: 'operationFailed',
      desc: '',
      args: [],
    );
  }

  /// `操作成功`
  String get operationSucceeded {
    return Intl.message(
      '操作成功',
      name: 'operationSucceeded',
      desc: '',
      args: [],
    );
  }

  /// `开始阅读`
  String get startReading {
    return Intl.message(
      '开始阅读',
      name: 'startReading',
      desc: '',
      args: [],
    );
  }

  /// `在书架`
  String get onTheBookshelf {
    return Intl.message(
      '在书架',
      name: 'onTheBookshelf',
      desc: '',
      args: [],
    );
  }

  /// `加入书架`
  String get addTheBookshelf {
    return Intl.message(
      '加入书架',
      name: 'addTheBookshelf',
      desc: '',
      args: [],
    );
  }

  /// `最新`
  String get latest {
    return Intl.message(
      '最新',
      name: 'latest',
      desc: '',
      args: [],
    );
  }

  /// `目录`
  String get catalog {
    return Intl.message(
      '目录',
      name: 'catalog',
      desc: '',
      args: [],
    );
  }

  /// `关闭`
  String get close {
    return Intl.message(
      '关闭',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `显示`
  String get show {
    return Intl.message(
      '显示',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `进入`
  String get entry {
    return Intl.message(
      '进入',
      name: 'entry',
      desc: '',
      args: [],
    );
  }

  /// `商店连接失败`
  String get storeUnAvailable {
    return Intl.message(
      '商店连接失败',
      name: 'storeUnAvailable',
      desc: '',
      args: [],
    );
  }

  /// `商店查询失败`
  String get storeError {
    return Intl.message(
      '商店查询失败',
      name: 'storeError',
      desc: '',
      args: [],
    );
  }

  /// `商店内为空`
  String get storeEmpty {
    return Intl.message(
      '商店内为空',
      name: 'storeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `应用程式升级`
  String get appUpgrade {
    return Intl.message(
      '应用程式升级',
      name: 'appUpgrade',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get ok {
    return Intl.message(
      '确定',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `总计`
  String get total {
    return Intl.message(
      '总计',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `章`
  String get chapter {
    return Intl.message(
      '章',
      name: 'chapter',
      desc: '',
      args: [],
    );
  }

  /// `书架`
  String get bookshelf {
    return Intl.message(
      '书架',
      name: 'bookshelf',
      desc: '',
      args: [],
    );
  }

  /// `书城`
  String get bookStore {
    return Intl.message(
      '书城',
      name: 'bookStore',
      desc: '',
      args: [],
    );
  }

  /// `福利`
  String get welfare {
    return Intl.message(
      '福利',
      name: 'welfare',
      desc: '',
      args: [],
    );
  }

  /// `我的`
  String get mine {
    return Intl.message(
      '我的',
      name: 'mine',
      desc: '',
      args: [],
    );
  }

  /// `跳过`
  String get skip {
    return Intl.message(
      '跳过',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `热门搜索`
  String get searchHot {
    return Intl.message(
      '热门搜索',
      name: 'searchHot',
      desc: '',
      args: [],
    );
  }

  /// `换一批`
  String get searchShake {
    return Intl.message(
      '换一批',
      name: 'searchShake',
      desc: '',
      args: [],
    );
  }

  /// `历史搜索`
  String get searchHistory {
    return Intl.message(
      '历史搜索',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `清空`
  String get clear {
    return Intl.message(
      '清空',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `重试`
  String get retry {
    return Intl.message(
      '重试',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `男生`
  String get male {
    return Intl.message(
      '男生',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `女生`
  String get female {
    return Intl.message(
      '女生',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `短篇`
  String get shortStory {
    return Intl.message(
      '短篇',
      name: 'shortStory',
      desc: '',
      args: [],
    );
  }

  /// `漫画`
  String get comic {
    return Intl.message(
      '漫画',
      name: 'comic',
      desc: '',
      args: [],
    );
  }

  /// `免费`
  String get free {
    return Intl.message(
      '免费',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `付费`
  String get charge {
    return Intl.message(
      '付费',
      name: 'charge',
      desc: '',
      args: [],
    );
  }

  /// `会员`
  String get member {
    return Intl.message(
      '会员',
      name: 'member',
      desc: '',
      args: [],
    );
  }

  /// `20万字以下`
  String get less20w {
    return Intl.message(
      '20万字以下',
      name: 'less20w',
      desc: '',
      args: [],
    );
  }

  /// `20万-50万字`
  String get between20wTo50w {
    return Intl.message(
      '20万-50万字',
      name: 'between20wTo50w',
      desc: '',
      args: [],
    );
  }

  /// `50万-100万字`
  String get between50wTo100w {
    return Intl.message(
      '50万-100万字',
      name: 'between50wTo100w',
      desc: '',
      args: [],
    );
  }

  /// `100万-200万字`
  String get between100wTo200w {
    return Intl.message(
      '100万-200万字',
      name: 'between100wTo200w',
      desc: '',
      args: [],
    );
  }

  /// `200万字以上`
  String get over200w {
    return Intl.message(
      '200万字以上',
      name: 'over200w',
      desc: '',
      args: [],
    );
  }

  /// `完结`
  String get complete {
    return Intl.message(
      '完结',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `连载`
  String get serial {
    return Intl.message(
      '连载',
      name: 'serial',
      desc: '',
      args: [],
    );
  }

  /// `状态`
  String get bookState {
    return Intl.message(
      '状态',
      name: 'bookState',
      desc: '',
      args: [],
    );
  }

  /// `价格`
  String get bookPrice {
    return Intl.message(
      '价格',
      name: 'bookPrice',
      desc: '',
      args: [],
    );
  }

  /// `字数`
  String get bookWordCount {
    return Intl.message(
      '字数',
      name: 'bookWordCount',
      desc: '',
      args: [],
    );
  }

  /// `全部`
  String get all {
    return Intl.message(
      '全部',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `待付款`
  String get unfinished {
    return Intl.message(
      '待付款',
      name: 'unfinished',
      desc: '',
      args: [],
    );
  }

  /// `已完成`
  String get finished {
    return Intl.message(
      '已完成',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `作品!`
  String get works {
    return Intl.message(
      '作品!',
      name: 'works',
      desc: '',
      args: [],
    );
  }

  /// `以周为单位，连续签到奖励\n第一天，可获得10个书币\n第二天，可获得20个书币\n第三天，可获得30个书币\n第四天，可获得40个书币\n第五天，可获得50个书币\n第六天，可获得60个书币\n第七天，可获得70个书币\n这是一个周期，下一个周重复此规则，获得的书币长久有效，可用于购买书籍，如果签到中断，则重新计算。`
  String get checkInRulesText {
    return Intl.message(
      '以周为单位，连续签到奖励\n第一天，可获得10个书币\n第二天，可获得20个书币\n第三天，可获得30个书币\n第四天，可获得40个书币\n第五天，可获得50个书币\n第六天，可获得60个书币\n第七天，可获得70个书币\n这是一个周期，下一个周重复此规则，获得的书币长久有效，可用于购买书籍，如果签到中断，则重新计算。',
      name: 'checkInRulesText',
      desc: '',
      args: [],
    );
  }

  /// `搜索`
  String get search {
    return Intl.message(
      '搜索',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `商店评分`
  String get storeReview {
    return Intl.message(
      '商店评分',
      name: 'storeReview',
      desc: '',
      args: [],
    );
  }

  /// `当前已是最新版本`
  String get currentlyLatestVersion {
    return Intl.message(
      '当前已是最新版本',
      name: 'currentlyLatestVersion',
      desc: '',
      args: [],
    );
  }

  /// `版本更新`
  String get upgrade {
    return Intl.message(
      '版本更新',
      name: 'upgrade',
      desc: '',
      args: [],
    );
  }

  /// `关于我们`
  String get about {
    return Intl.message(
      '关于我们',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `多语言`
  String get multiLanguage {
    return Intl.message(
      '多语言',
      name: 'multiLanguage',
      desc: '',
      args: [],
    );
  }

  /// `跟随系统`
  String get followSystem {
    return Intl.message(
      '跟随系统',
      name: 'followSystem',
      desc: '',
      args: [],
    );
  }

  /// `隐私权政策`
  String get privacyPolicy {
    return Intl.message(
      '隐私权政策',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `服务条款`
  String get termsOfService {
    return Intl.message(
      '服务条款',
      name: 'termsOfService',
      desc: '',
      args: [],
    );
  }

  /// `重试`
  String get viewStateButtonRetry {
    return Intl.message(
      '重试',
      name: 'viewStateButtonRetry',
      desc: '',
      args: [],
    );
  }

  /// `加载失败`
  String get viewStateMessageError {
    return Intl.message(
      '加载失败',
      name: 'viewStateMessageError',
      desc: '',
      args: [],
    );
  }

  /// `空空如也`
  String get viewStateMessageEmpty {
    return Intl.message(
      '空空如也',
      name: 'viewStateMessageEmpty',
      desc: '',
      args: [],
    );
  }

  /// `刷新一下`
  String get viewStateButtonRefresh {
    return Intl.message(
      '刷新一下',
      name: 'viewStateButtonRefresh',
      desc: '',
      args: [],
    );
  }

  /// `未登录`
  String get viewStateMessageUnAuth {
    return Intl.message(
      '未登录',
      name: 'viewStateMessageUnAuth',
      desc: '',
      args: [],
    );
  }

  /// `下拉可刷新`
  String get refreshIdle {
    return Intl.message(
      '下拉可刷新',
      name: 'refreshIdle',
      desc: '',
      args: [],
    );
  }

  /// `释放可刷新`
  String get refreshRefreshWhenRelease {
    return Intl.message(
      '释放可刷新',
      name: 'refreshRefreshWhenRelease',
      desc: '',
      args: [],
    );
  }

  /// `刷新中`
  String get refreshing {
    return Intl.message(
      '刷新中',
      name: 'refreshing',
      desc: '',
      args: [],
    );
  }

  /// `刷新完成`
  String get refreshComplete {
    return Intl.message(
      '刷新完成',
      name: 'refreshComplete',
      desc: '',
      args: [],
    );
  }

  /// `欢迎光临,我的空中楼阁`
  String get refreshTwoLevel {
    return Intl.message(
      '欢迎光临,我的空中楼阁',
      name: 'refreshTwoLevel',
      desc: '',
      args: [],
    );
  }

  /// `加载中...`
  String get loadMoreLoading {
    return Intl.message(
      '加载中...',
      name: 'loadMoreLoading',
      desc: '',
      args: [],
    );
  }

  /// `没有更多数据了`
  String get loadMoreNoData {
    return Intl.message(
      '没有更多数据了',
      name: 'loadMoreNoData',
      desc: '',
      args: [],
    );
  }

  /// `上拉加载更多`
  String get loadMoreIdle {
    return Intl.message(
      '上拉加载更多',
      name: 'loadMoreIdle',
      desc: '',
      args: [],
    );
  }

  /// `加载失败,请点击重试`
  String get loadMoreFailed {
    return Intl.message(
      '加载失败,请点击重试',
      name: 'loadMoreFailed',
      desc: '',
      args: [],
    );
  }

  /// `网络连接异常,请检查网络或稍后重试`
  String get viewStateMessageNetworkError {
    return Intl.message(
      '网络连接异常,请检查网络或稍后重试',
      name: 'viewStateMessageNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `开源小说客户端`
  String get appSlogan {
    return Intl.message(
      '开源小说客户端',
      name: 'appSlogan',
      desc: '',
      args: [],
    );
  }

  /// `小说`
  String get appName {
    return Intl.message(
      '小说',
      name: 'appName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
