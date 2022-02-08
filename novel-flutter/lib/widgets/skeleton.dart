import 'package:flutter/material.dart';

/// 尺寸骨架
class SizeSkeleton extends StatelessWidget {
  final double? width;
  final double? height;

  const SizeSkeleton({this.width, this.height});

  const SizeSkeleton.expand()
      : width = double.infinity,
        height = double.infinity;

  const SizeSkeleton.shrink()
      : width = 0.0,
        height = 0.0;

  SizeSkeleton.fromSize({Key? key, Size? size})
      : width = size?.width,
        height = size?.height,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    if (width != null && height != null) {
      return Container(
        width: width,
        height: height,
        color: isDark ? Colors.grey[700] : Colors.grey[300],
      );
    } else {
      return Container(
        color: isDark ? Colors.grey[700] : Colors.grey[300],
      );
    }
  }
}

/// 容器骨架
class ContainerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final BoxShape shape; //  BoxShape.circle/rectangle

  const ContainerSkeleton({
    required this.width,
    required this.height,
    required this.shape,
  });

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: shape,
        border: const Border(bottom: BorderSide(width: 0.3)),
        color: isDark ? Colors.grey[700] : Colors.grey[300],
      ),
    );
  }
}

/// 列表骨架
class ListSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final Widget item;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;

  const ListSkeleton({
    Key? key,
    required this.itemCount,
    required this.item,
    required this.padding,
    required this.separatorBuilder,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: separatorBuilder,
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
