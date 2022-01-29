import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';

/// 书籍频道
class BookChannel {
  static const int all = 0; // 全部
  static const int male = 0x01; // 男生
  static const int female = 0x02; // 女生
  static const int shortStory = 0x04; // 短篇
  static const int comic = 0x08; // 漫画

  static String getLabel(BuildContext context, int id) {
    if (id == male) {
      return S.of(context).male;
    } else if (id == female) {
      return S.of(context).female;
    } else if (id == shortStory) {
      return S.of(context).shortStory;
    } else if (id == comic) {
      return S.of(context).comic;
    } else {
      return 'unknown';
    }
  }
}
