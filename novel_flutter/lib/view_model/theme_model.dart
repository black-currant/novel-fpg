import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kThemeIndex = 'themeIndex';
const kThemeColorIndex = 'themeColorIndex';
const kAppearanceIndex = 'appearanceIndex';

const kTextScaleFactor = 'textScaleFactor';
const kWidthScale = 'widthScale';

/// APP的UI主题
/// 明暗模式，主题颜色，字体
class ThemeModel with ChangeNotifier {
  late double _widthScale;
  late double _textScaleFactor;

  ThemeModel() {
    _appearanceIndex =
        Persistence.sharedPreferences.getInt(kAppearanceIndex) ?? 0;
    _widthScale = Persistence.sharedPreferences.getDouble(kWidthScale) ?? 1.0;
    _textScaleFactor =
        Persistence.sharedPreferences.getDouble(kTextScaleFactor) ?? 1.0;
    debugPrint(
        'Theme data:appearance=$_appearanceIndex,scaleText=$_widthScale, textScaleFactor=$_textScaleFactor');
  }

  /// 切换指定色彩
  ///
  /// 没有传[brightness]就不改变brightness,color同理
  void switchTheme({
    int? appearanceIndex,
    double? widthScale,
    double? textScaleFactor,
  }) {
    _appearanceIndex = appearanceIndex ?? _appearanceIndex;
    _widthScale = widthScale ?? _widthScale;
    _textScaleFactor = textScaleFactor ?? _textScaleFactor;
    notifyListeners();
    saveTheme2Storage(_appearanceIndex, _widthScale, _textScaleFactor);
  }

  /// 数据持久化到shared preferences
  saveTheme2Storage(
      int appearanceIndex, double scaleText, double textScaleFactor) async {
    var prefs = Persistence.sharedPreferences;
    await Future.wait([
      prefs.setInt(kAppearanceIndex, appearanceIndex),
      prefs.setDouble(kWidthScale, scaleText),
      prefs.setDouble(kTextScaleFactor, textScaleFactor),
    ]);
  }

  double getFontSize(double fontSize) {
    return (fontSize * _widthScale) / _textScaleFactor;
  }

  /// 主题
  ThemeData get theme => ThemeData.light().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.white,
          primaryVariant: Colors.white,
          secondary: Color(0xFF00C29A),
          secondaryVariant: Color(0xFF00C29A),
          surface: Colors.white,
          background: Colors.white,
        ),
        toggleableActiveColor: const Color(0xFF00C29A),
        indicatorColor: const Color(0xFF00C29A),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: ThemeData.light().textTheme.headline6!.copyWith(
                    fontSize: getFontSize(34),
                  ),
              subtitle1: ThemeData.light().textTheme.subtitle1!.copyWith(
                    fontSize: getFontSize(28),
                    color: Colors.black,
                  ),
              subtitle2: ThemeData.light().textTheme.subtitle2!.copyWith(
                    fontSize: getFontSize(24),
                    color: Colors.black,
                  ),
              caption: ThemeData.light().textTheme.caption!.copyWith(
                    fontSize: getFontSize(20),
                    color: Colors.black,
                  ),
              button: ThemeData.light().textTheme.button!.copyWith(
                    fontSize: getFontSize(26),
                    color: Colors.black,
                  ),
            ),
        textSelectionTheme: ThemeData.light().textSelectionTheme.copyWith(
              cursorColor: const Color(0xFF00C29A).withAlpha(60),
              selectionColor: const Color(0xFF00C29A).withAlpha(60),
              selectionHandleColor: const Color(0xFF00C29A).withAlpha(60),
            ),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              centerTitle: true,
              elevation: 0.0,
              titleTextStyle: TextStyle(
                fontSize: getFontSize(34),
                color: Colors.black,
              ),
              iconTheme: const IconThemeData(color: Colors.black),
            ),
        bottomNavigationBarTheme:
            ThemeData.light().bottomNavigationBarTheme.copyWith(
                  selectedItemColor: const Color(0xFF00C29A),
                ),
        tabBarTheme: ThemeData.light().tabBarTheme.copyWith(
              labelColor: const Color(0xFF00C29A),
              unselectedLabelColor: Colors.black38,
              indicatorSize: TabBarIndicatorSize.label,
            ),
        cardTheme: ThemeData.light().cardTheme.copyWith(
              elevation: 0,
              margin: const EdgeInsets.all(0),
            ),
        chipTheme: ThemeData.light().chipTheme.copyWith(
              selectedColor: const Color(0xFF00C29A),
              pressElevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              labelStyle: ThemeData.light().textTheme.caption,
              backgroundColor:
                  ThemeData.light().chipTheme.backgroundColor.withOpacity(0.1),
            ),
      );

  /// 暗色主题
  ThemeData get darkTheme => ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.light(
          secondary: Color(0xFF00C29A),
          secondaryVariant: Color(0xFF00C29A),
        ),
        toggleableActiveColor: const Color(0xFF00C29A),
        indicatorColor: const Color(0xFF00C29A),
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              centerTitle: true,
            ),
        bottomNavigationBarTheme:
            ThemeData.dark().bottomNavigationBarTheme.copyWith(),
      );

  // 外观，跟随系统，浅色模式，深色模式
  // 0跟随系统，1浅色，2深色
  final _appearances = [0, 1, 2];

  int get appearancesLength => _appearances.length;

  late int _appearanceIndex;

  int get appearanceIndex => _appearanceIndex;

  /// 外观
  String appearanceLabel(index, context) {
    switch (index) {
      case 0:
        return S.of(context).followSystem;
      case 1:
        return S.of(context).lightModel;
      case 2:
        return S.of(context).darkModel;
      default:
        return '';
    }
  }

  String currentAppearanceLabel(context) =>
      appearanceLabel(_appearanceIndex, context);
}
