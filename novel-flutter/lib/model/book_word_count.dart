import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';

/// 书籍字数
class BookWordCount {
  static const int less20w = 1; //
  static const int between20wTo50w = 2; //
  static const int between50wTo100w = 3; //
  static const int between100wTo200w = 4; //
  static const int over200w = 5; //

  static String getLabel(BuildContext context, int id) {
    if (id == less20w) {
      return S.of(context).less20w;
    } else if (id == between20wTo50w) {
      return S.of(context).between20wTo50w;
    } else if (id == between50wTo100w) {
      return S.of(context).between50wTo100w;
    } else if (id == between100wTo200w) {
      return S.of(context).between100wTo200w;
    } else if (id == over200w) {
      return S.of(context).over200w;
    } else {
      return S.of(context).bookWordCount;
    }
  }
}
