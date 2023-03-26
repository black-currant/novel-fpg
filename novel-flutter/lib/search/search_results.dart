import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/search_model.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 搜索结果页
class SearchResultsPage extends StatelessWidget {
  final String keyword;
  final SearchHistoryModel searchHistoryModel;

  const SearchResultsPage({
    Key? key,
    required this.keyword,
    required this.searchHistoryModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<SearchResultModel>(
      model: SearchResultModel(
          keyword: keyword, searchHistoryModel: searchHistoryModel),
      onModelReady: (model) {
        model.initData();
      },
      builder: (context, model, child) {
        if (model.isBusy) {
          return ListShimmer(
            separatorBuilder: (context, index) => spaceDividerMedium,
            padding: pageEdgeInsets,
            itemCount: 9,
            item: const BookSkeletonMedium(),
          );
        } else if (model.isError && model.list.isEmpty) {
          return ViewStateErrorWidget(
            error: model.viewStateError!,
            onPressed: model.initData,
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
          enablePullUp: !model.isEmpty,
          onLoading: model.loadMore,
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              height: dividerMediumSize,
              color: Colors.transparent,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: verticalMargin,
              horizontal: horizontalMargin,
            ),
            shrinkWrap: true,
            itemCount: model.list.length,
            itemBuilder: (context, index) {
              final item = model.list[index];
              return BookItemMedium(item: item);
            },
          ),
        );
      },
    );
  }
}
