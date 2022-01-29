import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/edit_state.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html;

/// 书架的增删改
class BookshelfModel extends ViewStateRefreshListModel<Book> {
  late LocalBookshelfModel _localModel;

  BookshelfModel() {
    _localModel = LocalBookshelfModel();
  }

//  BookshelfModel(this.languageTag, this.localBookshelfModel) {
//    assert(localBookshelfModel != null);
//  }

  @override
  Future<List<Book>> loadData({required int pageNum}) async {
    if (pageNum > ViewStateRefreshListModel.pageNumFirst) {
      return [];
    }

    var data = await serverAPI.bookshelfList();

    /// 去HTML标签
    for (var element in data) {
      element.intro = html.parse(element.intro).body!.text;
    }
    return data;
  }

  @override
  onCompleted(List<Book> data) {
    _localModel.addBook(data);
    return super.onCompleted(data);
  }

  // 编辑书架，选择的书籍ID
  final List<int> _selectedBookIds = [];

  void cleanSelect() {
    _selectedBookIds.clear();
    for (var book in list) {
      book.selected = false;
    }
  }

  void addSelect(int id) {
    if (_selectedBookIds.contains(id)) return;
    _selectedBookIds.add(id);
  }

  void unSelect(int id) {
    if (!_selectedBookIds.contains(id)) return;
    _selectedBookIds.remove(id);
  }

  bool get isAllSelected => list.length == _selectedBookIds.length;

  bool get hasSelected => _selectedBookIds.isNotEmpty;

  int get selectedCount => _selectedBookIds.length;

  Future<bool> update(EditState state) async {
    setBusy();
    try {
      bool successful =
          await serverAPI.updateBookshelf(_selectedBookIds, state);
      if (successful) {
        if (state == EditState.add) {
          refresh(init: true); // 刷新列表
        } else if (state == EditState.remove) {
          list.removeWhere((item) => _selectedBookIds.contains(item.id));
          _localModel.delBook(_selectedBookIds);
        }
      }
      if (list.isEmpty) {
        setEmpty();
      } else {
        setIdle();
      }

      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  // 本地数据
  bool get hasBook => _localModel.hasBook; // 书架有书

  bool inBookshelf(int bookId) => _localModel.inBookshelf(bookId);

  @override
  void dispose() {
//    super.dispose();
    cleanSelect();
  }
}

/// 本地书架信息
/// 不再需要
class LocalBookshelfModel extends ChangeNotifier {
  List<int> _bookIds = []; // 书籍ID列表

  LocalBookshelfModel() {
    var key = getKey();
    if (key != null) {
      var data = Persistence.localStorage.getItem(key);
      if (data != null && data.isNotEmpty) {
        for (var item in data) {
          _bookIds.add(item);
        }
      }
    }
  }

  List<int> get data => _bookIds;

  bool get hasBook => _bookIds.isNotEmpty; // 书架有书

  bool inBookshelf(int bookId) => _bookIds.contains(bookId);

  String? getKey() {
    int? userId = Persistence.sharedPreferences.getInt(kUserId);
    if (userId == null) return null;
    return kBookshelf(userId);
  }

  addBook(List<Book> data) {
    for (var i = 0; i < data.length; i++) {
      int id = data[i].id ?? 0;
      if (_bookIds.contains(id)) continue;
      _bookIds.add(id);
    }
    save();
  }

  delBook(List<int> bookIds) {
    for (var item in bookIds) {
      _bookIds.remove(item);
    }
    save();
  }

  save() {
    notifyListeners();
    var key = getKey();
    if (key != null) {
      Persistence.localStorage.setItem(key, _bookIds);
    }
  }

  clean() {
    _bookIds = [];
    notifyListeners();
    var key = getKey();
    if (key != null) Persistence.localStorage.deleteItem(key);
  }
}
