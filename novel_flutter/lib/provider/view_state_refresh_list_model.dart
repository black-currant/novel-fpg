import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'view_state_model.dart';

/// 分页加载的列表
abstract class ViewStateRefreshListModel<T> extends ViewStateModel {
  /// 页面数据
  List<T> list = [];

  /// 默认分页第一页页码
  static const int pageNumFirst = 0;

  final _refreshController = RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  /// 当前页码，初始值为0
  int _currentPageNum = pageNumFirst;

  /// 分页条目数量
  int pageSize = defaultPageSize;

  /// 第一次进入页面loading skeleton
  initData({bool duringBuild = false}) async {
    setBusy(duringBuild: duringBuild);
    await refresh(init: true);
  }

  /// 下拉刷新
  ///
  /// [init] 是否是第一次加载
  /// true:  Error时,需要跳转页面
  /// false: Error时,不需要跳转页面,直接给出提示
  Future<List<T>?> refresh({bool init = false}) async {
    try {
      _currentPageNum = pageNumFirst; // 下拉刷新，页码归零
      var data = await loadData(pageNum: pageNumFirst);
      if (data.isEmpty) {
        refreshController.refreshCompleted(resetFooterState: true);
        list.clear();
        setEmpty();
      } else {
        onCompleted(data);
        list.clear();
        list.addAll(data);
        refreshController.refreshCompleted();
        // 小于分页的数量,禁止上拉加载更多
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          //防止上次上拉加载更多失败,需要重置状态
          refreshController.loadComplete();
        }
        setIdle();
      }
      return data;
    } catch (exception, stackTrace) {
      print('$exceptionCaughtBySelf: $exception ${exception.runtimeType}');
      print('$stackTraceTag: $stackTrace ${stackTrace.runtimeType}');

      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) list.clear();
      refreshController.refreshFailed();
      setError(exception, stackTrace);

      return null;
    }
  }

  /// 上拉加载更多
  Future<List<T>?> loadMore() async {
    try {
      var data = await loadData(pageNum: ++_currentPageNum);
      if (data.isEmpty) {
        _currentPageNum--;
        refreshController.loadNoData();
      } else {
        onCompleted(data);
        list.addAll(data);
        if (data.length < pageSize) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        notifyListeners();
      }
      return data;
    } catch (exception, stackTrace) {
      print('$exceptionCaughtBySelf: $exception ${exception.runtimeType}');
      print('$stackTraceTag: $stackTrace ${stackTrace.runtimeType}');

      _currentPageNum--;
      refreshController.loadFailed();
      return null;
    }
  }

  // 加载数据
  Future<List<T>> loadData({required int pageNum});

  onCompleted(List<T> data) {}

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
