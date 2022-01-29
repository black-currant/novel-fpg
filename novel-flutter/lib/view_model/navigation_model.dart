import 'package:flutter/material.dart';

import 'bookshelf_model.dart';

/// 导航器
class NavigationModel with ChangeNotifier {
  late int _selectedIndex;

  NavigationModel(BookshelfModel bookshelfModel) {
    _selectedIndex = bookshelfModel.hasBook ? 0 : 1;
    debugPrint('Selected home tab index $_selectedIndex.');
  }

  int get selectedIndex => _selectedIndex;

  select(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
