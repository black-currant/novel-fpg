import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';

/// 书籍状态
class BookState {
  static const int complete = 1; //已完结
  static const int serial = 0; //连载中

  static String getLabel(BuildContext context, int id) {
    if (id == complete) {
      return S.of(context).complete;
    } else if (id == serial) {
      return S.of(context).serial;
    } else {
      return S.of(context).bookState;
    }
  }
}
