import 'dart:math';

import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/discovery/check_in_shimmer.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// '发现'页面的骨架
class DiscoveryShimmer extends StatelessWidget {
  const DiscoveryShimmer({Key? key}) : super(key: key);

  Widget _buildItem(double width) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizeSkeleton(width: 6, height: 18),
            const SpaceDivider.medium(),
            SizeSkeleton(
              width: Random.secure().nextDouble() * width,
              height: 18,
            ),
          ],
        ),
        const SpaceDivider.medium(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: const <Widget>[
                    SizeSkeleton(
                      width: 48,
                      height: 18,
                    ),
                    SpaceDivider.medium(),
                    SizeSkeleton(
                      width: 48,
                      height: 18,
                    ),
                  ],
                ),
                const SpaceDivider.medium(),
                SizeSkeleton(
                  width: Random.secure().nextDouble() * width,
                  height: 16,
                ),
              ],
            ),
            const SizeSkeleton(
              width: 64.0,
              height: 32.0,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var width = MediaQuery.of(context).size.width / 2;
    return Padding(
      padding: pageEdgeInsets,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1200),
        baseColor: isDark ? const Color(0xFF616161) : const Color(0xFFE0E0E0),
        highlightColor:
            isDark ? const Color(0xFF9E9E9E) : const Color(0xFFEEEEEE),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const CheckInSkeleton(),
            const SpaceDivider.medium(),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => spaceDividerMedium,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                itemBuilder: (context, index) => _buildItem(width),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
