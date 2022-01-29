import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookstore//book_item_small.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/bookstore/bookcover_item.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_list_model.dart';
import 'package:novel_flutter/widgets/book_section_header.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';

/// 书籍推荐
///
/// 每日精选
/// 主编力推
/// 猜你喜欢
/// 同类精品

/// 每日精选
class DailyPicksView extends StatelessWidget {
  const DailyPicksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BookListModel>(
      model: BookListModel(pageSize: 8),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return SizedBox(
            height: bookCoverHeight,
            child: ListShimmer(
              separatorBuilder: (context, index) => spaceDividerSmall,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              itemCount: 8,
              item: const BookCoverSkeleton(),
            ),
          );
        } else if (model.isError) {
          return ViewStateErrorWidget(
              error: model.viewStateError!, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookSectionHeader(label: S.of(context).dailyPicks),
            const SpaceDivider.small(),
            SizedBox(
              height: bookCoverHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                itemCount: model.list.length,
                itemBuilder: (context, index) =>
                    BookCoverItem(book: model.list[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 主编力推
class EditorChoiceView extends StatelessWidget {
  const EditorChoiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BookListModel>(
      model: BookListModel(pageSize: 6),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return ListShimmer(
            separatorBuilder: (context, index) => spaceDividerMedium,
            itemCount: 6,
            item: BookSkeletonMedium(),
          );
        } else if (model.isError) {
          return ViewStateErrorWidget(
              error: model.viewStateError!, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookSectionHeader(
              label: S.of(context).editorChoice,
              action: S.of(context).changeBatch,
              onPressed: () {
                model.list.clear();
                model.loadMore();
              },
            ),
            const SpaceDivider.small(),
            ListView.separated(
              separatorBuilder: (context, index) => spaceDividerMedium,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.list.length,
              itemBuilder: (context, index) => BookItemMedium(
                item: model.list[index],
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 猜你喜欢
class MaybeLikeView extends StatelessWidget {
  final Book book;
  final bool pushReplacement;

  const MaybeLikeView({
    Key? key,
    required this.book,
    required this.pushReplacement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BookListModel>(
      model: BookListModel(
//              typeId: _book.category,
          pageSize: 3),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return ListShimmer(
            separatorBuilder: (context, index) => spaceDividerMedium,
            padding: const EdgeInsets.all(0.0),
            itemCount: 6,
            item: BookSkeletonMedium(),
          );
        } else if (model.isError) {
          return ViewStateErrorWidget(
              error: model.viewStateError!, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookSectionHeader(
              label: S.of(context).maybeLike,
              action: S.of(context).changeBatch,
              onPressed: () {
                model.list = [];
                model.loadMore();
              },
            ),
            const SpaceDivider.small(),
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: dividerMediumSize,
                color: Colors.transparent,
              ),
              padding: const EdgeInsets.all(0.0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: model.list.length,
              itemBuilder: (context, index) => BookItemMedium(
                item: model.list[index],
                pushReplacement: pushReplacement,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// 同类精品
class SameTypeView extends StatelessWidget {
  final Book book;
  final bool pushReplacement;

  const SameTypeView({
    Key? key,
    required this.book,
    required this.pushReplacement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BookListModel>(
      model: BookListModel(
        // typeId: _book.category,
        pageSize: 8,
      ),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return GridShimmer(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: bookItemSmallAspectRatio(),
              crossAxisSpacing: dividerMediumSize,
              mainAxisSpacing: dividerMediumSize,
            ),
            padding: const EdgeInsets.all(0.0),
            itemCount: 8,
            item: BookSkeletonSmall(),
          );
        } else if (model.isError) {
          return ViewStateErrorWidget(
              error: model.viewStateError!, onPressed: model.initData);
        } else if (model.isEmpty) {
          return ViewStateEmptyWidget(onPressed: model.initData);
        }
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BookSectionHeader(
              label: S.of(context).sameType,
              action: S.of(context).changeBatch,
              onPressed: () {
                model.list = [];
                model.loadMore();
              },
            ),
            const SpaceDivider.small(),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: bookItemSmallAspectRatio(),
                crossAxisSpacing: dividerMediumSize,
                mainAxisSpacing: dividerMediumSize,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 4.0),
              itemCount: model.list.length,
              itemBuilder: (context, index) => BookItemSmall(
                item: model.list[index],
                pushReplacement: pushReplacement,
              ),
            ),
          ],
        );
      },
    );
  }
}
