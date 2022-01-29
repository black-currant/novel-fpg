import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';

/// 书籍价格
class BookPrice {
  static const int free = 1; // 免费
  static const int charge = 2; // 付费
  static const int member = 3; // 会员

  static String getLabel(BuildContext context, int id) {
    if (id == free) {
      return S.of(context).free;
    } else if (id == charge) {
      return S.of(context).charge;
    } else if (id == member) {
      return S.of(context).member;
    } else {
      return S.of(context).bookPrice;
    }
  }
}
