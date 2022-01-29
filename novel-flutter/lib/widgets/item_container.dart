import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';

/// 项容器
class ItemContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double verPadding;
  final double horPadding;
  final double verMargin;
  final double horMargin;

  const ItemContainer({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.verPadding = itemPadding,
    this.horPadding = itemPadding,
    this.verMargin = 0.0, // verticalMargin,
    this.horMargin = 0.0, // horizontalMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (width != null && height == null) {
      widget = Container(
        width: width,
        padding: EdgeInsets.symmetric(
          vertical: verPadding,
          horizontal: horPadding,
        ),
        margin: EdgeInsets.symmetric(
          vertical: verMargin,
          horizontal: horMargin,
        ),
        decoration: itemDecoration(context: context),
        child: child,
      );
    } else if (width == null && height != null) {
      widget = Container(
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verPadding,
          horizontal: horPadding,
        ),
        margin: EdgeInsets.symmetric(
          vertical: verMargin,
          horizontal: horMargin,
        ),
        decoration: itemDecoration(context: context),
        child: child,
      );
    } else if (width != null && height != null) {
      widget = Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: verPadding,
          horizontal: horPadding,
        ),
        margin: EdgeInsets.symmetric(
          vertical: verMargin,
          horizontal: horMargin,
        ),
        decoration: itemDecoration(context: context),
        child: child,
      );
    } else {
      widget = Container(
        padding: EdgeInsets.symmetric(
          vertical: verPadding,
          horizontal: horPadding,
        ),
        margin: EdgeInsets.symmetric(
          vertical: verMargin,
          horizontal: horMargin,
        ),
        decoration: itemDecoration(context: context),
        child: child,
      );
    }
    return widget;
  }
}
