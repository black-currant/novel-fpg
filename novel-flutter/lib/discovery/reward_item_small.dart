import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/reward.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/utils/util.dart';

/// 签到项视图
/// 小号视图，垂直显示
class RewardItemSmall extends StatelessWidget {
  final Reward reward;

  const RewardItemSmall({Key? key, required this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var unit = '';
    if (reward.incentiveId == taskIdCheckIn) {
      unit = S.of(context).day;
    } else if (reward.incentiveId == taskIdReadingTime) {
      unit = '\n' + S.of(context).minutes;
    }
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Image(
                image: AssetImage(Util.assetImage(reward.isIssued()
                    ? 'reward_disable.png'
                    : 'reward_bg.png')),
              ),
              Text('+' + reward.name,
                  maxLines: 1,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reward.condition + unit,
            maxLines: 2,
            style: reward.isIssued()
                ? Theme.of(context)
                    .textTheme
                    .subtitle2!
                    .copyWith(color: const Color(0xFFff9100))
                : Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
