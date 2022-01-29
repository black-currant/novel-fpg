import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/search.dart';
import 'package:novel_flutter/provider/view_state_list_model.dart';
import 'package:novel_flutter/view_model/search_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 搜索的意见建议
/// 包括热门搜索和搜索历史
class SearchSuggestionsPage<T> extends StatelessWidget {
  final SearchDelegate<T>? delegate;

  const SearchSuggestionsPage({Key? key, this.delegate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconTheme(
                data: Theme.of(context)
                    .iconTheme
                    .copyWith(opacity: 0.6, size: 16),
                child: MultiProvider(
                  providers: [
                    Provider<TextStyle>.value(
                        value: Theme.of(context).textTheme.subtitle2!),
                    ProxyProvider<TextStyle, Color>(
                      update: (context, textStyle, _) =>
                          textStyle.color!.withOpacity(0.5),
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SearchHotKeysWidget(delegate: delegate!),
                      SearchHistoriesWidget(delegate: delegate!),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 热门搜索
class SearchHotKeysWidget extends StatefulWidget {
  final SearchDelegate delegate;

  const SearchHotKeysWidget({required this.delegate, key}) : super(key: key);

  @override
  _SearchHotKeysWidgetState createState() => _SearchHotKeysWidgetState();
}

class _SearchHotKeysWidgetState extends State<SearchHotKeysWidget> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      Provider.of<SearchHotKeyModel>(context, listen: false).initData();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 4,
                    height: 16,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: accentDecoration,
                  ),
                  Text(
                    S.of(context).searchHot,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Consumer<SearchHotKeyModel>(
                builder: (context, model, child) {
                  return Visibility(
                      visible: model.isBusy,
                      child: model.isIdle
                          ? TextButton.icon(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.subtitle2,
                              ),
                              onPressed: model.shuffle,
                              icon: Icon(
                                Icons.autorenew,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                              label: Text(
                                S.of(context).searchShake,
                              ))
                          : TextButton.icon(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.subtitle2,
                              ),
                              onPressed: model.initData,
                              icon: const Icon(Icons.refresh),
                              label: Text(S.of(context).retry)));
                },
              )
            ],
          ),
        ),
        SearchSuggestionStateWidget<SearchHotKeyModel, SearchHotKey>(
          builder: (context, item) => ActionChip(
            label: Text(item.name),
            onPressed: () {
              widget.delegate.query = item.name;
              widget.delegate.showResults(context);
            },
          ),
        ),
      ],
    );
  }
}

/// 历史搜索
class SearchHistoriesWidget<T> extends StatefulWidget {
  final SearchDelegate<T> delegate;

  const SearchHistoriesWidget({required this.delegate, key}) : super(key: key);

  @override
  _SearchHistoriesWidgetState createState() => _SearchHistoriesWidgetState();
}

class _SearchHistoriesWidgetState extends State<SearchHistoriesWidget> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      Provider.of<SearchHistoryModel>(context, listen: false).initData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 4,
                    height: 16,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: accentDecoration,
                  ),
                  Text(
                    S.of(context).searchHistory,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Consumer<SearchHistoryModel>(
                builder: (context, model, child) => Visibility(
                    visible: !model.isBusy && !model.isEmpty,
                    child: model.isIdle
                        ? TextButton.icon(
                            // textColor: Provider.of<Color>(context),
                            onPressed: model.clearHistory,
                            icon: Icon(
                              Icons.clear,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            label: Text(S.of(context).clear))
                        : TextButton.icon(
                            // textColor: Provider.of<Color>(context),
                            onPressed: model.initData,
                            icon: Icon(
                              Icons.refresh,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            label: Text(S.of(context).retry))),
              ),
            ],
          ),
        ),
        SearchSuggestionStateWidget<SearchHistoryModel, String>(
          builder: (context, item) => ActionChip(
            label: Text(item),
            onPressed: () {
              widget.delegate.query = item;
              widget.delegate.showResults(context);
            },
          ),
        ),
      ],
    );
  }
}

class SearchSuggestionStateWidget<T extends ViewStateListModel, E>
    extends StatelessWidget {
  final Widget Function(BuildContext context, E data) builder;

  const SearchSuggestionStateWidget({Key? key, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<T>(
      builder: (context, model, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: model.isIdle
            ? Wrap(
                alignment: WrapAlignment.start,
                spacing: 10,
                children: List.generate(model.list.length, (index) {
                  E item = model.list[index];
                  return builder(context, item);
                }),
              )
            : Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                alignment: Alignment.center,
                child: Builder(builder: (context) {
                  if (model.isBusy) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: CupertinoActivityIndicator(),
                    );
                  } else if (model.isError) {
                    return const Icon(
                      Icons.error_outline_rounded,
                      size: 60,
                      color: Colors.grey,
                    );
                  } else if (model.isEmpty) {
                    return const Icon(
                      Icons.hourglass_empty_rounded,
                      size: 70,
                      color: Colors.grey,
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ),
      ),
    );
  }
}
