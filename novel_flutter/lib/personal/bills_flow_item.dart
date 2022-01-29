import 'dart:math';

import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/model/score_flow.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:flutter/material.dart';

/// 书币流水项
class ScoreFlowItem extends StatelessWidget {
  final ScoreFlow item;
  final GestureTapCallback? onTap;

  const ScoreFlowItem({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(itemPadding),
      decoration: itemDecoration(context: context),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: <Widget>[
            Text(
              item.score > 0 ? '+${item.score}' : '${item.score}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  item.remark,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            Text(
              item.createTime,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreFlowSkeleton extends StatelessWidget {
  const ScoreFlowSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizeSkeleton(width: 20, height: 20),
        const SpaceDivider.medium(),
        SizeSkeleton(
          width: Random.secure().nextDouble() * width,
          height: 20,
        ),
        const SpaceDivider.medium(),
        const Expanded(
          child: SizeSkeleton(
            width: double.infinity,
            height: 20,
          ),
        ),
        const SpaceDivider.medium(),
      ],
    );
  }
}
