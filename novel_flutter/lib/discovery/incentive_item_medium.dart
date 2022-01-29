import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/navigation_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 福利的任务项视图
/// 中号视图，水平显示
class IncentiveItem extends StatelessWidget {
  final Incentive incentive;

  const IncentiveItem({Key? key, required this.incentive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var reward =
        '+' + incentive.virtualCurrency + S.of(context).virtualCurrency;
    var languageTag = Localizations.localeOf(context).toLanguageTag();
    return Container(
      padding: const EdgeInsets.all(itemPadding),
      decoration: itemDecoration(context: context),
      child: Flex(
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
                      incentive.getTitle(languageTag),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(width: 10),
                    Image.asset(Util.assetImage('gold.png')),
                    const SizedBox(width: 5),
                    Text(
                      reward,
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: const Color(0xFFff9100)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  incentive.getDescription(languageTag),
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              onPressed(context);
            },
            child: Container(
              width: 64.0,
              height: 32.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).colorScheme.secondary, width: 1),
                borderRadius: const BorderRadius.all(Radius.circular(25)),
              ),
              child: Text(
                incentive.isCompleted()
                    ? S.of(context).completed
                    : incentive.getActionLabel(languageTag),
                style: Theme.of(context).textTheme.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onPressed(BuildContext context) async {
    if (incentive.taskID == taskIdFirstRecharge) {
      // Navigator.of(context).pushNamed(RouteName.productList);
    }
    // else if (incentive.taskID == taskIdBindFacebook ||
    //     incentive.taskID == taskIdBindWeChat) {
    //   if (checkLogin(context: context)) return;
    //   Navigator.of(context).pushNamed(RouteName.accountSecurity);
    // }
    else if (incentive.taskID == taskIdShare) {
      Provider.of<NavigationModel>(context, listen: false).select(1);
    }
  }
}
