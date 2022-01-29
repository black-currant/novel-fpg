import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book_filter.dart';
import 'package:novel_flutter/model/book_price.dart';
import 'package:novel_flutter/model/book_state.dart';
import 'package:novel_flutter/model/book_word_count.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:flutter/material.dart';

/// 书籍过滤
class BookFilterModel extends ViewStateModel {
  final List<BookFilter> _list = [];
  bool dropUp = false;
  late int _filter;
  late int _currentIndex = 0;

  Future<List> loadData(BuildContext context, int filter) {
    setBusy();
    try {
      _list.clear();
      _filter = filter;
      if (filter == BookFilter.bookState) {
        _list.add(BookFilter(-1, S.of(context).bookState, true));
        _list.add(BookFilter(BookState.serial, S.of(context).serial, false));
        _list
            .add(BookFilter(BookState.complete, S.of(context).complete, false));
      } else if (filter == BookFilter.bookPrice) {
        _list.add(BookFilter(-1, S.of(context).bookPrice, true));
        _list.add(BookFilter(BookPrice.member, S.of(context).member, false));
        _list.add(BookFilter(BookPrice.free, S.of(context).free, false));
      } else {
        _list.add(BookFilter(-1, S.of(context).bookWordCount, true));
        _list.add(
            BookFilter(BookWordCount.less20w, S.of(context).less20w, false));
        _list.add(BookFilter(BookWordCount.between20wTo50w,
            S.of(context).between20wTo50w, false));
        _list.add(BookFilter(BookWordCount.between50wTo100w,
            S.of(context).between50wTo100w, false));
        _list.add(BookFilter(BookWordCount.between100wTo200w,
            S.of(context).between100wTo200w, false));
        _list.add(
            BookFilter(BookWordCount.over200w, S.of(context).over200w, false));
      }
      setIdle();
      return Future.value(_list);
    } catch (e, s) {
      setError(e, s);
      return Future.value([]);
    }
  }

  bool get isDropUp => dropUp;

  int get filter => _filter;

  String get currentLabel => _list[_currentIndex].name;

  List<BookFilter> get list => _list;

  toggle() {
    dropUp = !dropUp;
    notifyListeners();
  }

  select(int index) {
    _currentIndex = index;
    for (var i = 0; i < _list.length; i++) {
      var item = _list[i];
      item.selected = i == index;
    }
    notifyListeners();
  }
}
