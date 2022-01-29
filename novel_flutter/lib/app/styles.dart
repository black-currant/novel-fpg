import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';

/// 强调色装饰器
/// 圆角，渐变
var accentDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(buttonRadius),
  gradient: accentGradient,
);

const accentGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [Color(0xFF5ce693), Color(0xFF48e0b8)],
);

/// 输入框的装饰器
/// 圆角，阴影
BoxDecoration textFieldDecoration({
  required BuildContext context,
  double radius: textFieldRadius,
}) {
  final shadowColor = Theme.of(context).brightness == Brightness.dark
      ? Colors.transparent
      : const Color(0xFFF5F5F5);
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    boxShadow: [
      BoxShadow(
        color: shadowColor,
        offset: const Offset(0.0, 2.0),
        blurRadius: radius,
      )
    ],
  );
}

/// 项的装饰器
/// 设计效果，圆角，阴影
BoxDecoration itemDecoration({
  required BuildContext context,
  double radius: itemRadius,
}) {
  var isDark = Theme.of(context).brightness == Brightness.dark;
  var shadowColor = isDark ? Colors.transparent : const Color(0xFFF5F5F5);
  return BoxDecoration(
    color: Theme.of(context).cardColor,
    borderRadius: BorderRadius.all(Radius.circular(radius)),
    boxShadow: [
      BoxShadow(
          color: shadowColor,
          offset: const Offset(0.0, 2.0),
          blurRadius: radius)
    ],
  );
}

/// 空间分割器，适合有背景色的页面
const spaceDividerMedium = Divider(
  height: dividerMediumSize,
  color: Colors.transparent,
);

const spaceDividerSmall = Divider(
  height: dividerSmallSize,
  color: Colors.transparent,
);

const spaceDividerTiny = Divider(
  height: dividerTinySize,
  color: Colors.transparent,
);

const pageEdgeInsets = EdgeInsets.symmetric(
  vertical: verticalMargin,
  horizontal: horizontalMargin,
);

const itemEdgeInsets = EdgeInsets.symmetric(
  vertical: itemPadding,
  horizontal: itemPadding,
);
