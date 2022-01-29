import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/platformizations.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookshelf/book_edit_item.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/edit_state.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/bookshelf_model.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 书架列表视图
class EditBookshelfPage extends StatelessWidget {
  const EditBookshelfPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context, BookshelfModel model) {
    if (model.isBusy) {
      return ListShimmer(
        separatorBuilder: (context, index) => spaceDividerMedium,
        padding: pageEdgeInsets,
        itemCount: 9,
        item: const BookEditSkeleton(),
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
      onRefresh: () {
        model.cleanSelect();
        model.refresh();
      },
      enablePullUp: false,
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
          return BookEditItem(
            item: model.list[index],
            onTap: (selected, id) {
              if (selected) {
                model.addSelect(id);
              } else {
                model.unSelect(id);
              }
              model.setIdle();
            },
          );
        },
      ),
    );
  }

  /// 移出书架警告对话框
  void _showMoveBookDialog(BuildContext context, BookshelfModel model) {
    var content = Text(
      S.of(context).removeBookMsg(model.selectedCount),
      style: Theme.of(context).textTheme.subtitle1,
    );
    onPositiveTap() async {
      Navigator.pop(context);
      await model.update(EditState.remove);
      if (model.isError) {
        model.showErrorMessage(context);
        return;
      }
    }

    platformizations.showAlertDialog(
        context: context, content: content, onPositiveTap: onPositiveTap);
  }

  PreferredSizeWidget? _buildAppBar(
      BuildContext context, BookshelfModel model) {
    return AppBar(
      title: Text(
        S.of(context).bookshelf,
      ),
      actions: <Widget>[
        IconButton(
          onPressed: () {
            bool action = model.isAllSelected;
            for (var book in model.list) {
              book.selected = !action;
              book.selected
                  ? model.addSelect(book.id!)
                  : model.unSelect(book.id!);
            }
            debugPrint('Bookshelf selected count ${model.selectedCount}');
            model.setIdle();
          },
          icon: Text(
            model.isAllSelected
                ? S.of(context).unSelectAll
                : S.of(context).selectAll,
            maxLines: 1,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ),
        Offstage(
          offstage: !model.hasSelected,
          child: IconButton(
            onPressed: () {
              _showMoveBookDialog(context, model);
            },
            icon: Text(
              S.of(context).delete,
              maxLines: 1,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    BookshelfModel model = Provider.of<BookshelfModel>(context, listen: false);
    return ProviderWidget<BookshelfModel>(
      model: model,
      builder: (_, model, child) {
        return Scaffold(
          appBar: _buildAppBar(context, model),
          body: _buildBody(context, model), //bottomSheet: _buildOperateSheet(),
        );
      },
    );
  }
}
