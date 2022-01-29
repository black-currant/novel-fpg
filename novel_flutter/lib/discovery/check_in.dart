import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/discovery/check_in_result_dialog.dart';
import 'package:novel_flutter/discovery/check_in_shimmer.dart';
import 'package:novel_flutter/discovery/reward_item_small.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/model/reward.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/book_list_model.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:novel_flutter/view_model/reward_receive_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/widgets/book_section_header.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 签到
class CheckInPage extends StatefulWidget {
  final Incentive? incentive;

  const CheckInPage({Key? key, this.incentive}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CheckInPage> {
  void setup() async {}

  @override
  void initState() {
    super.initState();
    setup();
  }

  Widget _buildTipsAndRule(Incentive item) {
    String emptyPlace = '    ';
    return Container(
      width: double.infinity,
      height: 90,
      alignment: Alignment.bottomLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: S.of(context).checkInMessage + emptyPlace,
              style: Theme.of(context).textTheme.headline6,
            ),
            TextSpan(
              text: item.isCompleted()
                  ? '${item.progress + 1}'
                  : '${item.progress}',
              style: TextStyle(
                  fontSize: 48.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.secondary),
            ),
            TextSpan(
              text: emptyPlace + S.of(context).day,
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReward(List<Reward> items) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            const SizedBox(width: double.infinity, height: 40),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(Util.assetImage('number_7.png')),
                ),
                Text(
                  S.of(context).checkInSlogan,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ],
        ),
        Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 26),
              width: double.infinity,
              height: 4,
              decoration: const BoxDecoration(color: Color(0xFFffd83d)),
            ),
            SizedBox(
              height: 80,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 3 / 5,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 0,
                ),
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    RewardItemSmall(reward: items[index]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookRecommend() {
    UserModel model = Provider.of(context, listen: false);
    int readingPrefs = model.user.preference!;
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BookSectionHeader(label: S.of(context).maybeLike),
          const SizedBox(height: 10),
          ProviderWidget<BookListModel>(
            model: BookListModel(value: readingPrefs, pageSize: 1),
            onModelReady: (model) => model.initData(),
            builder: (context, model, child) {
              if (model.isBusy) {
                return const ContainerShimmer(
                  child: BookSkeletonMedium(),
                );
              } else if (model.isError) {
                return ViewStateErrorWidget(
                    error: model.viewStateError!, onPressed: model.initData);
              } else if (model.isEmpty) {
                return ViewStateEmptyWidget(onPressed: model.initData);
              }
              return BookItemMedium(
                item: model.list[0],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return ProviderWidget2<IncentivesModel, RewardReceiveModel>(
      model1: IncentivesModel(),
      model2:
          RewardReceiveModel(userModel: Provider.of(context, listen: false)),
      onModelReady: (model1, model2) async {
        model1.checkIn = widget.incentive;
        if (model1.checkIn == null) {
          await model1.initData();
        } else {
          model1.setIdle();
        }
        assert(model1.checkIn != null);
        if (model1.checkIn != null && !model1.checkIn!.isCompleted()) {
          await model2.request(model1.checkIn!.taskID);
          if (model2.isError) {
            model2.showErrorMessage(context);
            return;
          }
          model1.checkIn!.status = 1;
          int index = model1.checkIn!.progress;
          Reward reward = model1.checkIn!.rewards[index];
          reward.issued = true;
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return CheckInResultDialog(
                reward: '', // reward.name,
                progress: index + 1,
              );
            },
          );
          // 刷新任务数据
          Provider.of<IncentivesModel>(context, listen: false).checkIn =
              model1.checkIn;
        }
      },
      builder: (_, model1, model2, child) {
        if (model1.isBusy) {
          return const CheckInShimmer();
        } else if (model1.isError) {
          return ViewStateWidget(onPressed: model1.initData());
        } else if (model1.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model1.initData());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            vertical: verticalMargin,
            horizontal: horizontalMargin,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTipsAndRule(model1.checkIn!),
              const SpaceDivider(width: 1, height: 48),
              _buildReward(model1.checkIn!.rewards),
              const SpaceDivider(width: 1, height: 48),
              _buildBookRecommend(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).checkIn),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                RouteName.text,
                arguments: [
                  S.of(context).checkInRule,
                  S.of(context).checkInRulesText
                ],
              );
            },
            padding: const EdgeInsets.all(0.0),
            icon: const Icon(Icons.help_outline),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
