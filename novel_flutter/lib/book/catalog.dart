import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/book/catalog_item_small.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/catalog_list_model.dart';
import 'package:novel_flutter/view_model/consume_score_model.dart';
import 'package:novel_flutter/widgets/item_container.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 书籍目录
/// 外部携带章节数据则不发送请求
class CatalogPage extends StatefulWidget {
  final Book book;

  const CatalogPage({Key? key, required this.book}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CatalogPage> {
  late Book _book;
  late ConsumeScoreModel _consumeScoreModel;

  @override
  void initState() {
    super.initState();
    _book = widget.book;
    _consumeScoreModel = ConsumeScoreModel(Provider.of(context, listen: false));
  }

  @override
  void dispose() {
    _consumeScoreModel.dispose();
    super.dispose();
  }

  Widget _buildHeader(var model) {
    return ItemContainer(
      width: double.infinity,
      height: 48.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            S.of(context).total +
                model.chapterCount.toString() +
                S.of(context).chapter,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          IconButton(
            onPressed: () {
              model.toggleSort();
              setState(() {});
            },
            padding: const EdgeInsets.all(0.0),
            icon: Image.asset(
              model.isAscSort()
                  ? Util.assetImage("sort_asc.png")
                  : Util.assetImage("sort_desc.png"),
              color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: pageEdgeInsets,
      child: ProviderWidget<CatalogListModel>(
        model: CatalogListModel(
            fileUrl: Util.netFile('${_book.catalogLink}'),
            bookId: _book.id!,
            chapterPrice: _book.chapterCost ?? 0,
            chapterFreeCount: _book.freeChapterCnt ?? 0,
            chapterCnt: _book.chapterCnt ?? 0,
            sort: sortAsc),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return ListShimmer(
              separatorBuilder: (context, index) => spaceDividerMedium,
              padding: pageEdgeInsets,
              itemCount: 20,
              item: const CatalogSkeletonSmall(),
            );
          } else if (model.isError) {
            return ViewStateErrorWidget(
                error: model.viewStateError!, onPressed: model.initData);
          } else if (model.isEmpty) {
            return ViewStateEmptyWidget(onPressed: model.initData);
          }
          return Column(
            children: <Widget>[
              _buildHeader(model),
              const SpaceDivider.medium(),
              Expanded(
                child: ItemContainer(
                  child: SmartRefresher(
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
                      separatorBuilder: (context, index) => spaceDividerSmall,
                      shrinkWrap: true,
                      padding: itemEdgeInsets,
                      itemCount: model.list.length,
                      itemBuilder: (context, index) {
                        return CatalogItemSmall(
                            model: _consumeScoreModel,
                            item: model.list[index],
                            bookId: _book.id!);
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${_book.title}'),
      ),
      body: _buildBody(),
    );
  }
}
