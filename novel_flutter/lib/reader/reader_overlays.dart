import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'battery_view.dart';

/// 阅读器叠加层
///
/// 阅读器的页眉，页脚
/// 章节名，电量，时间，页码
class ReaderOverlays extends StatelessWidget {
  final Chapter chapter;
  final int pageIndex;
  final double topSafeHeight;
  final double bottomSafeHeight;

  ReaderOverlays({
    required this.chapter,
    required this.pageIndex,
    required this.topSafeHeight,
    required this.bottomSafeHeight,
  });

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('HH:mm');
    var time = format.format(DateTime.now());

    return Container(
      padding: EdgeInsets.fromLTRB(ReaderConfig.leftOffset, 10 + topSafeHeight,
          ReaderConfig.rightOffset, 10 + bottomSafeHeight),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(chapter.title ?? '',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: ReaderConfig.golden)),
          Expanded(child: Container()),
          Row(
            children: <Widget>[
              BatteryView(),
              SizedBox(width: 10),
              Text(
                time,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: ReaderConfig.golden),
              ),
              Expanded(child: Container()),
              Text(
                S.of(context).num +
                    (pageIndex + 1).toString() +
                    S.of(context).page,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: ReaderConfig.golden),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
