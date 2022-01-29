import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/discovery/incentive_item_medium.dart';
import 'package:novel_flutter/discovery/incentive_item_reading.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/widgets/book_section_header.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/material.dart';

/// 阅读福利
class ReadingIncentiveView extends StatelessWidget {
  final List<Incentive> data;

  const ReadingIncentiveView({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BookSectionHeader(label: S.of(context).readingIncentive),
        const SpaceDivider.small(),
        ListView.separated(
          separatorBuilder: (context, index) => spaceDividerMedium,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            Incentive incentive = data[index];
            if (incentive.taskID == taskIdReadingTime) {
              return ReadingIncentiveItem(
                incentive: incentive,
              );
            } else {
              return IncentiveItem(incentive: incentive);
            }
          },
        ),
      ],
    );
  }
}
