import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/discovery/reward_item_small.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/navigation_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 阅读时长任务
class ReadingIncentiveItem extends StatelessWidget {
  final Incentive incentive;

  const ReadingIncentiveItem({Key? key, required this.incentive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localeTitleDescription = incentive.localeTitleDescription.split('; ');
    var reward = incentive.rewards[incentive.progress];
    var name = localeTitleDescription[1].replaceFirst('{0}', reward.condition);
    var desc = localeTitleDescription[2].replaceAll('{0}', reward.condition);
    var rewardName = '+' + reward.name + S.of(context).virtualCurrency;
    var action = incentive
        .getActionLabel(Localizations.localeOf(context).toLanguageTag());
    return Container(
      padding: const EdgeInsets.all(itemPadding),
      decoration: itemDecoration(context: context),
      child: Column(
        children: <Widget>[
          Flex(
            direction: Axis.horizontal,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          name,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        const SizedBox(width: 10),
                        Image.asset(Util.assetImage('gold.png')),
                        const SizedBox(width: 5),
                        Text(
                          rewardName,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: const Color(0xFFff9100)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  NavigationModel model =
                      Provider.of<NavigationModel>(context, listen: false);
                  model.select(0);
                },
                child: Container(
                  width: 64,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Text(
                    incentive.isCompleted() ? S.of(context).completed : action,
                    style: Theme.of(context).textTheme.button,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 100,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 3 / 6,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: incentive.rewards.length,
              itemBuilder: (context, index) => RewardItemSmall(
                reward: incentive.rewards[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}
