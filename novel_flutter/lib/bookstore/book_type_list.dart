import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/bookstore/book_type_item.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_types_model.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 书籍类型列表
class BookTypeListPage extends StatefulWidget {
  final int channelId; // 频道ID

  const BookTypeListPage({Key? key, required this.channelId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BookTypeListPage>
    with AutomaticKeepAliveClientMixin {
  late int _channelId;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _channelId = widget.channelId;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget<BookTypesModel>(
      model: BookTypesModel(
          channelId: _channelId,
          languageTag: Localizations.localeOf(context).toLanguageTag()),
      onModelReady: (model) => model.initData(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return GridShimmer(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: bookTypeItemAspectRatio(),
              crossAxisSpacing: 20,
              mainAxisSpacing: dividerMediumSize,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: verticalMargin,
              horizontal: 24,
            ),
            itemCount: 20,
            item: BookTypeSkeleton(),
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
          enablePullDown: !model.isEmpty,
          onRefresh: model.refresh,
          enablePullUp: false,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: bookTypeItemAspectRatio(),
              crossAxisSpacing: 20,
              mainAxisSpacing: dividerMediumSize,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: verticalMargin,
              horizontal: 24,
            ),
            shrinkWrap: true,
            itemCount: model.list.length,
            itemBuilder: (context, index) {
              return BookTypeItem(
                item: model.list[index],
              );
            },
          ),
        );
      },
    );
  }
}
