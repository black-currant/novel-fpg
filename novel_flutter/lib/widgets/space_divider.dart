import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';

/// 空间分割器，适合有背景色
class SpaceDivider extends StatelessWidget {
  final double? width;
  final double? height;

  const SpaceDivider({Key? key, this.width, this.height}) : super(key: key);

  const SpaceDivider.tiny({Key? key})
      : width = dividerTinySize,
        height = dividerTinySize,
        super(key: key);

  const SpaceDivider.small({Key? key})
      : width = dividerSmallSize,
        height = dividerSmallSize,
        super(key: key);

  const SpaceDivider.medium({Key? key})
      : width = dividerMediumSize,
        height = dividerMediumSize,
        super(key: key);

  const SpaceDivider.large({Key? key})
      : width = dividerLargeSize,
        height = dividerLargeSize,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height);
  }
}
