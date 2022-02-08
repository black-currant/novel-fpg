import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookstore/book_filter_popup.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/model/book_filter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_list_model.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 书籍列表视图
class BookListPage extends StatelessWidget {
  final int value; // 类型ID
  final String title;
  late BookListModel _bookListModel;

  BookListPage({Key? key, required this.value, required this.title})
      : super(key: key);

  Widget _buildSortAndFilter(BuildContext context, BookListModel model) {
    return Flex(
      crossAxisAlignment: CrossAxisAlignment.center,
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: BookFilterPopup(
            filter: BookFilter.bookState,
            onCallback: (value) {
              model.setBookState(value);
              model.initData();
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: BookFilterPopup(
            filter: BookFilter.bookPrice,
            onCallback: (value) {
              model.setBookPrice(value);
              model.initData();
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: BookFilterPopup(
            filter: BookFilter.bookWordCount,
            onCallback: (value) {
              model.setWordCount(value);
              model.initData();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return ProviderWidget<BookListModel>(
      model: _bookListModel,
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return ListShimmer(
            separatorBuilder: (context, index) => spaceDividerMedium,
            padding: pageEdgeInsets,
            itemCount: 9,
            item: const BookSkeletonMedium(),
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
            padding: pageEdgeInsets,
            shrinkWrap: true,
            itemCount: model.list.length,
            itemBuilder: (context, index) => BookItemMedium(
              item: model.list[index],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _bookListModel = BookListModel(value: value);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        bottom: PreferredSize(
          child: _buildSortAndFilter(context, _bookListModel),
          preferredSize: const Size(double.infinity, 28),
        ),
      ),
      body: _buildBody(context),
    );
  }
}
