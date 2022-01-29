import 'dart:io';

import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/view_model/theme_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Platformizations platformizations = Platformizations();

/// 应用平台化，使应用尽量符合所在运行平台的设计规范，同时界面展示交互会有差异性。
///
/// iOS设计规范 https://developer.apple.com/design/human-interface-guidelines/ios/overview/themes/
/// Android设计规范 https://developer.android.google.cn/design?hl=en
///
/// 如果是iOS平台，使用iOS Style，如果是Android平台，使用Material design。比如：Android的title是靠左，而iOS的title是居中的。
///
class Platformizations {
  static Platformizations? _instance;

  /// 单例
  factory Platformizations() {
    _instance ??= Platformizations._();
    return _instance!;
  }

  /// 命名构造函数
  Platformizations._();

  get backIcon => Platform.isAndroid
      ? const Icon(Icons.arrow_back)
      : const Icon(Icons.arrow_back_ios);

  // get centerTitle => true; //Platform.isIOS;

  get moreIcon => Platform.isAndroid
      ? const Icon(Icons.more_horiz)
      : const Icon(Icons.more_vert);

  get phoneIcon =>
      Platform.isAndroid ? Icons.phone_android : Icons.phone_iphone;

  get pagePhysics => Platform.isAndroid
      ? const ClampingScrollPhysics()
      : const BouncingScrollPhysics();

  Future<T?> showAlertDialog<T>(
      {required BuildContext context,
      Widget? title,
      Widget? content,
      Widget? positiveText,
      bool positiveOffstage = false,
      VoidCallback? onPositiveTap,
      Widget? negativeText,
      bool negativeOffstage = false,
      VoidCallback? onNegativeTap,
      bool barrierDismissible = true}) {
    positiveText = positiveText ??
        Text(S.of(context).ok, style: Theme.of(context).textTheme.button);
    onPositiveTap = onPositiveTap ??
        () {
          Navigator.pop(context);
        };
    negativeText = negativeText ??
        Text(S.of(context).cancel, style: Theme.of(context).textTheme.button);
    onNegativeTap = onNegativeTap ??
        () {
          Navigator.pop(context);
        };
    if (Platform.isIOS) {
      return showCupertinoDialog<T>(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                Offstage(
                  offstage: negativeOffstage,
                  child: CupertinoDialogAction(
                      onPressed: onNegativeTap, child: negativeText!),
                ),
                Offstage(
                  offstage: positiveOffstage,
                  child: CupertinoDialogAction(
                      onPressed: onPositiveTap, child: positiveText!),
                ),
              ],
            );
          });
    } else {
      return showDialog<T>(
          context: context,
          barrierDismissible: barrierDismissible,
          builder: (BuildContext context) {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                Offstage(
                  offstage: negativeOffstage,
                  child: TextButton(
                      onPressed: onNegativeTap, child: negativeText!),
                ),
                Offstage(
                  offstage: positiveOffstage,
                  child: TextButton(
                      onPressed: onPositiveTap, child: positiveText!),
                ),
              ],
            );
          });
    }
  }

  /// 屏幕本地化
  /// 屏幕适配
  /// 字号
  screen(BuildContext context) {
    /// 适配字号
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double widthScale = (mediaQuery.size.width / designWidth);
    double textScaleFactor = mediaQuery.textScaleFactor;
    Provider.of<ThemeModel>(context, listen: false).switchTheme(
      widthScale: widthScale,
      textScaleFactor: textScaleFactor,
    );
  }
}
