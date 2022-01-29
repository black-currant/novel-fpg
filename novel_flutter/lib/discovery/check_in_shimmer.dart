import 'dart:math';

import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CheckInSkeleton extends StatelessWidget {
  const CheckInSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            SizeSkeleton(
              width: 120.0,
              height: 24.0,
            ),
            SizeSkeleton(
              width: 24.0,
              height: 24.0,
            ),
          ],
        ),
        const SpaceDivider.medium(),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 3 / 5,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 0.0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 7,
          itemBuilder: (context, index) =>
              const SizeSkeleton(width: 10, height: 10),
        ),
      ],
    );
  }
}

/// 签到
class CheckInShimmer extends StatelessWidget {
  const CheckInShimmer({Key? key}) : super(key: key);

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
            Container(
              alignment: Alignment.bottomLeft,
              height: 90,
              child: Row(
                children: [
                  SizeSkeleton(
                    width: Random.secure().nextDouble() * width,
                    height: 36,
                  ),
                  const SpaceDivider.medium(),
                  const SizeSkeleton(width: 24, height: 36),
                ],
              ),
            ),
            const SpaceDivider(width: 1, height: 48),
            const CheckInSkeleton(),
            const SpaceDivider(width: 1, height: 48),
            const BookSkeletonMedium(),
          ],
        ),
      ),
    );
  }
}
