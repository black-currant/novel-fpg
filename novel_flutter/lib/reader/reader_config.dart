import 'package:flutter/material.dart';

/// 阅读器静态配置
/// 一些参数的默认值
class ReaderConfig {
  /// 默认字体大小
  static const double fontSize = 18;
  static const double maxFontSize = 26;
  static const double minFontSize = 14;

  /// 因为不同机型上有不同的max brightness值，比如说小米cc9上亮度最大值是超过255的，不是标准的谷歌标准。
  /// 所以这块采用默认0.2，然后用户设置保存到数据库中，每回打开的时候设置一遍用户数据
  static const double screenBrightness = 0.2;

  /// 默认行高
  /// 因为算数精度，所以乘以10
  static const double lineHeight = 1.4;
  static const double maxLineHeight = 3.0;
  static const double minLineHeight = 1.0;

  /// 默认阅读锁屏，即默认有唤醒锁
  static const bool wakelock = true;

  static const Color golden = Color(0xff8B7961);

  /// 书籍正文的顶部，底部的高度偏移量
  static const double topOffset = 37;
  static const double bottomOffset = 37;
  static const double leftOffset = 15;
  static const double rightOffset = 10;

  /// 菜单背景色
  static const Color menuPrimaryColor = Color(0xFFEEEEEE);
  static const Color menuBackgroundColor = Colors.black;
  static const Color menuTitleText = Color(0xFFEEEEEE);

  static List<BoxShadow> get borderShadow {
    return const [BoxShadow(color: Color(0x22000000), blurRadius: 8)];
  }

  /// 菜单动画时长
  static const duration = 300;
}

const readerBgColors = {
  'daytime': Colors.white24, // 白天
  'night': Colors.black45, // 黑夜
  'parchment': Color.fromRGBO(242, 235, 217, 100), // 羊皮纸
  'eyeshield': Color.fromRGBO(199, 237, 204, 100), // 护眼
};
