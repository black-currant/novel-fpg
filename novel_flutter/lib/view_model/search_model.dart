import 'dart:async';

import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/search.dart';
import 'package:novel_flutter/provider/view_state_list_model.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:html/parser.dart' as html;
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String kLocalStorageSearch = 'kLocalStorageSearch';
const String kSearchHotList = 'kSearchHotList';
const String kSearchHistory = 'kSearchHistory';

/// 热搜关键字
class SearchHotKeyModel extends ViewStateListModel {
  @override
  Future<List> loadData() async {
    LocalStorage localStorage = LocalStorage(kLocalStorageSearch);
//    localStorage.deleteItem(keySearchHotList);//测试没有缓存
    await localStorage.ready;
    List localList =
        (localStorage.getItem(kSearchHotList) ?? []).map<SearchHotKey>((item) {
      return SearchHotKey.fromMap(item);
    }).toList();

    if (localList.isEmpty) {
      //缓存为空,需要同步加载网络数据
      List<String> netList = await serverAPI.searchHotKey();
      localStorage.setItem(kSearchHotList, netList);
      return netList;
    } else {
//      localList.removeRange(0, 3);//测试缓存与网络数据不一致
      serverAPI.searchHotKey().then((netList) {
        netList = netList ?? [];
        if (!const ListEquality().equals(netList, localList)) {
          list = netList;
          localStorage.setItem(kSearchHotList, list);
//          setIdle();
        }
      });
      return localList;
    }
  }

  shuffle() {
    list.shuffle();
    notifyListeners();
  }
}

/// 搜索历史
class SearchHistoryModel extends ViewStateListModel<String> {
  clearHistory() async {
    debugPrint('clear search history');
    var _prefs = await SharedPreferences.getInstance();
    _prefs.remove(kSearchHistory);
    list.clear();
    setEmpty();
  }

  addHistory(String keyword) async {
    var _prefs = await SharedPreferences.getInstance();
    var histories = _prefs.getStringList(kSearchHistory) ?? [];
    histories
      ..remove(keyword)
      ..insert(0, keyword);
    await _prefs.setStringList(kSearchHistory, histories);
    notifyListeners();
  }

  @override
  Future<List<String>> loadData() async {
    var _prefs = await SharedPreferences.getInstance();
    return _prefs.getStringList(kSearchHistory) ?? [];
  }
}

/// 搜索结果
class SearchResultModel extends ViewStateRefreshListModel {
  final String keyword;
  final SearchHistoryModel searchHistoryModel;

  SearchResultModel({required this.keyword, required this.searchHistoryModel});

  @override
  Future<List> loadData({required int pageNum}) async {
    if (keyword.isEmpty) return [];
    searchHistoryModel.addHistory(keyword);
    var data =
        await serverAPI.searchResult(keyword: keyword, pageIndex: pageNum);

    /// 去HTML标签
    data.forEach((element) {
      element.intro = html.parse(element.intro).body!.text;
    });
    return data;
  }
}
