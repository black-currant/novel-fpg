import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/personal/bills_flow_item.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/score_flow_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:novel_flutter/widgets/book_section_header.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 钱包
/// 当前余额，充值按钮，账单流水
class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WalletPage> {
  void setup() async {
    /// 刷新书币数据
    UserProfileModel model = UserProfileModel(
      userModel: Provider.of(context, listen: false),
    );
    await model.fetch();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Widget _buildHeaderView() {
    return Container(
      width: double.infinity,
      height: 120,
      padding: const EdgeInsets.all(itemPadding),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          ProviderWidget<UserModel>(
            autoDispose: false,
            model: Provider.of(context, listen: false),
            builder: (_, model, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    S.of(context).balance,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${model.user.score}',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 36,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: pageEdgeInsets,
      child: Column(
        children: <Widget>[
          _buildHeaderView(),
          const SpaceDivider.medium(),
//          _buildBillsFlow(),
          BookSectionHeader(label: S.of(context).incomeAndExpenditure),
          const SpaceDivider.small(),
          Expanded(
            child: ProviderWidget<ScoreFlowModel>(
              model: ScoreFlowModel(),
              onModelReady: (model) => model.initData(),
              builder: (context, model, child) {
                if (model.isBusy) {
                  return ListShimmer(
                    separatorBuilder: (context, index) => spaceDividerMedium,
                    padding: pageEdgeInsets,
                    itemCount: 20,
                    item: const ScoreFlowSkeleton(),
                  );
                } else if (model.isError) {
                  return ViewStateErrorWidget(
                      error: model.viewStateError!, onPressed: model.initData);
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
                  enablePullUp: !model.isEmpty,
                  onLoading: model.loadMore,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => spaceDividerMedium,
                    itemCount: model.list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        ScoreFlowItem(item: model.list[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).virtualCurrency),
      ),
      body: _buildBody(),
//      bottomSheet: _buildOperateSheet(),
    );
  }
}
