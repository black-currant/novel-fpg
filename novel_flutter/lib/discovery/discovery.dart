import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/discovery/discovery_shimmer.dart';
import 'package:novel_flutter/discovery/reading_incentive.dart';
import 'package:novel_flutter/discovery/reward_item_small.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/item_container.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// '发现'页面
class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DiscoveryPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildCheckIn(Incentive incentive) {
    return ItemContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
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
              InkWell(
                onTap: () {
                  if (checkLogin(context: context)) return;
                  Navigator.of(context)
                      .pushNamed(RouteName.checkIn, arguments: incentive);
                },
                child: Container(
                  width: 60.0,
                  height: 30.0,
                  alignment: Alignment.center,
                  decoration: accentDecoration,
                  child: Text(
                      incentive.isCompleted()
                          ? S.of(context).checkInAlready
                          : S.of(context).checkInAction,
                      style: Theme.of(context)
                          .textTheme
                          .button!
                          .copyWith(color: Colors.white)),
                ),
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
                    crossAxisSpacing: 0,
                    mainAxisSpacing: 0,
                  ),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
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
        ],
      ),
    );
  }

  /// 每隔一分钟刷新一次任务数据
  Stream refreshData() async* {}

  Widget _buildBody() {
    return ProviderWidget<IncentivesModel>(
      autoDispose: false,
      model: Provider.of<IncentivesModel>(context, listen: false),
      onModelReady: (model) => model.initData(duringBuild: true),
      builder: (_, model, child) {
        if (model.isBusy) {
          return const DiscoveryShimmer();
        } else if (model.isError) {
          return ViewStateErrorWidget(
            error: model.viewStateError!,
            onPressed: () async {
              switch (model.viewStateError!.errorType) {
                case ViewStateErrorType.unauthorizedError:
                  MyRouter.showLoginOptions(context);
                  var successful = await MyRouter.showLoginOptions(context);
                  // 登录成功,获取数据,刷新页面
                  if (successful ?? false) {
                    model.initData();
                  }
                  break;
                default:
                  model.initData();
                  break;
              }
            },
          );
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return SmartRefresher(
          controller: model.refreshController,
          header: WaterDropHeader(
            waterDropColor: Theme.of(context).colorScheme.secondary,
          ),
          footer: const RefresherFooter(),
          enablePullDown: !model.isEmpty,
          onRefresh: model.refresh,
          enablePullUp: false,
          child: SingleChildScrollView(
            padding: pageEdgeInsets,
            child: Column(
              children: <Widget>[
                _buildCheckIn(model.checkIn!),
                const SpaceDivider.medium(),
                const SpaceDivider.medium(),
                ReadingIncentiveView(data: model.reading),
                const SpaceDivider.medium(),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).welfareCenter),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}
