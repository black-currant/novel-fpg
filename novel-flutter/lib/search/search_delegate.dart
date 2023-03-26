import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/search/search_results.dart';
import 'package:novel_flutter/search/search_suggestions.dart';
import 'package:novel_flutter/view_model/search_model.dart';
import 'package:provider/provider.dart';

/// 应用内搜索代理
class MySearchDelegate extends SearchDelegate {
  final SearchHistoryModel _searchHistoryModel = SearchHistoryModel();
  final SearchHotKeyModel _searchHotKeyModel = SearchHotKeyModel();

  MySearchDelegate(BuildContext context)
      : super(
          searchFieldLabel: S.of(context).searchHint,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
        primaryColor: Theme.of(context).primaryColor,
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(fontSize: 16, color: Colors.black),
              subtitle1: ThemeData.light().textTheme.subtitle1!.copyWith(
                    color: Colors.black,
                  ),
              subtitle2: ThemeData.light().textTheme.subtitle2!.copyWith(
                    color: Colors.black,
                  ),
              caption: ThemeData.light().textTheme.caption!.copyWith(
                    color: Colors.black,
                  ),
              button: ThemeData.light().textTheme.button!.copyWith(
                    color: Colors.black,
                  ),
            ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontSize: 16),
          prefixStyle: TextStyle(),
        ));
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
            showSuggestions(context);
          }
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchHistoryModel>.value(
            value: _searchHistoryModel),
        ChangeNotifierProvider<SearchHotKeyModel>.value(
            value: _searchHotKeyModel),
      ],
      child: SearchSuggestionsPage(delegate: this),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      return SearchResultsPage(
          keyword: query, searchHistoryModel: _searchHistoryModel);
    }
    return const SizedBox.shrink();
  }

  @override
  void close(BuildContext context, result) {
//    _searchHistoryModel.dispose();
//    _searchHotKeyModel.dispose();
    super.close(context, result);
  }
}
