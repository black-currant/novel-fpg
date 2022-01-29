import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

const kLocaleIndex = 'localeIndex';

/// 本地化
/// 阅读顺序，多语言
class LocaleModel extends ChangeNotifier {
  // 界面上可供用户切换的语言列表
  final _localeValues = ['', 'zh-Hans', 'zh-Hant'];

  int get localeLength => _localeValues.length;

  String localeLabel(index, context) {
    switch (index) {
      case 0:
        return S.of(context).followSystem;
      case 1:
        return '简体中文';
      case 2:
        return '繁體中文';
      default:
        return '';
    }
  }

  String currentLabel(context) => localeLabel(_localeIndex, context);

  late int _localeIndex;

  int get localeIndex => _localeIndex;

  LocaleModel() {
    _localeIndex = Persistence.sharedPreferences.getInt(kLocaleIndex) ?? 0;
  }

  switchLocale(int? index) {
    _localeIndex = index ?? 0;
    notifyListeners();
    Persistence.sharedPreferences.setInt(kLocaleIndex, _localeIndex);
  }

  Locale? get locale {
    if (_localeIndex > 0) {
      var value = _localeValues[_localeIndex].split("-");
      debugPrint('Application locale customer $value.');
      return Locale.fromSubtags(
          languageCode: value[0],
          scriptCode: value.length == 2 ? value[1] : '');
    }
    // 跟随系统
    debugPrint('Application locale follow system.');
    return null;
  }
}
