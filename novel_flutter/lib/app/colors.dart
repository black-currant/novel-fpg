import 'package:flutter/material.dart';

/// 画布的颜色
const canvasColor = Colors.white;
const canvasColorDark = Color(0xFF191919);

/// 分隔器颜色
const dividerColor = Color(0xFFF6F6F8);
const dividerColorDark = canvasColorDark;

/// 定制页面背景色
/// 浅色为0xFFF6F6F8
/// 页面默认的背景色是画布的颜色，有一些页面特殊，比如设置页面，需要不同的背景色，则使用这个
Color tilePageBgColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? canvasColorDark
      : const Color(0xFFF6F6F8);
}
