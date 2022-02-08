import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 通用微光屏
class ContainerShimmer extends StatelessWidget {
  final Widget child;

  const ContainerShimmer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1200),
      baseColor: isDark ? const Color(0xFF616161) : const Color(0xFFE0E0E0),
      highlightColor:
          isDark ? const Color(0xFF9E9E9E) : const Color(0xFFEEEEEE),
      child: child,
    );
  }
}

/// 列表微光屏
class ListShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry? padding;
  final Widget item;
  final IndexedWidgetBuilder separatorBuilder;
  final Axis scrollDirection;

  const ListShimmer({
    Key? key,
    required this.itemCount,
    required this.item,
    this.padding,
    required this.separatorBuilder,
    this.scrollDirection = Axis.vertical,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.separated(
      separatorBuilder: separatorBuilder,
      padding: padding,
      shrinkWrap: true,
      scrollDirection: scrollDirection,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Shimmer.fromColors(
        period: const Duration(milliseconds: 1200),
        baseColor: isDark ? const Color(0xFF616161) : const Color(0xFFE0E0E0),
        highlightColor:
            isDark ? const Color(0xFF9E9E9E) : const Color(0xFFEEEEEE),
        child: item,
      ),
    );
  }
}

/// 网格微光屏
class GridShimmer extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final Widget item;
  final SliverGridDelegate gridDelegate;

  const GridShimmer({
    Key? key,
    required this.itemCount,
    required this.item,
    required this.padding,
    required this.gridDelegate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    return GridView.builder(
      gridDelegate: gridDelegate,
      padding: padding,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Shimmer.fromColors(
        period: const Duration(milliseconds: 1200),
        baseColor: isDark ? const Color(0xFF616161) : const Color(0xFFE0E0E0),
        highlightColor:
            isDark ? const Color(0xFF9E9E9E) : const Color(0xFFEEEEEE),
        child: item,
      ),
    );
  }
}
