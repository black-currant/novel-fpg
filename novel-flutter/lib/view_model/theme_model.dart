import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kTextScaleFactor = 'textScaleFactor';
const kWidthScale = 'widthScale';

/// 主题
/// 浅色/深色模式，颜色，字号
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

  /// 应用的主题
  ThemeData themeData(
      {bool platformDarkMode = false,
      double? scaleText,
      double? textScaleFactor}) {
    var isDark = false;
    if (_appearanceIndex == appearanceFollowSystem) {
      isDark = platformDarkMode;
    } else {
      isDark = _appearanceIndex == appearanceDark;
    }
    return isDark ? _darkTheme : _lightTheme;
  }

  /// 主题
  ThemeData get _lightTheme => ThemeData.light().copyWith(
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
        sliderTheme: ThemeData.light().sliderTheme.copyWith(
              inactiveTrackColor: Colors.black,
            ),
      );

  /// 暗色主题
  ThemeData get _darkTheme => ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF191919),
          primaryVariant: Color(0xFF191919),
          secondary: Color(0xFF00C29A),
          secondaryVariant: Color(0xFF00C29A),
          surface: Color(0xFF191919),
          background: Color(0xFF191919),
        ),
        toggleableActiveColor: const Color(0xFF00C29A),
        indicatorColor: const Color(0xFF00C29A),
        textTheme: ThemeData.dark().textTheme.copyWith(
              headline6: ThemeData.dark().textTheme.headline6!.copyWith(
                    fontSize: getFontSize(34),
                  ),
              subtitle1: ThemeData.dark().textTheme.subtitle1!.copyWith(
                    fontSize: getFontSize(28),
                    color: Colors.white,
                  ),
              subtitle2: ThemeData.dark().textTheme.subtitle2!.copyWith(
                    fontSize: getFontSize(24),
                    color: Colors.white,
                  ),
              caption: ThemeData.dark().textTheme.caption!.copyWith(
                    fontSize: getFontSize(20),
                    color: Colors.white,
                  ),
              button: ThemeData.dark().textTheme.button!.copyWith(
                    fontSize: getFontSize(26),
                    color: Colors.white,
                  ),
            ),
        textSelectionTheme: ThemeData.dark().textSelectionTheme.copyWith(
              cursorColor: const Color(0xFF00C29A).withAlpha(60),
              selectionColor: const Color(0xFF00C29A).withAlpha(60),
              selectionHandleColor: const Color(0xFF00C29A).withAlpha(60),
            ),
        appBarTheme: ThemeData.dark().appBarTheme.copyWith(
              centerTitle: true,
              elevation: 0.0,
              titleTextStyle: TextStyle(
                fontSize: getFontSize(34),
                color: Colors.white,
              ),
              iconTheme: const IconThemeData(color: Colors.white),
            ),
        bottomNavigationBarTheme:
            ThemeData.dark().bottomNavigationBarTheme.copyWith(
                  selectedItemColor: const Color(0xFF00C29A),
                ),
        tabBarTheme: ThemeData.dark().tabBarTheme.copyWith(
              labelColor: const Color(0xFF00C29A),
              unselectedLabelColor: Colors.white38,
              indicatorSize: TabBarIndicatorSize.label,
            ),
        cardTheme: ThemeData.dark().cardTheme.copyWith(
              elevation: 0,
              margin: const EdgeInsets.all(0),
            ),
        chipTheme: ThemeData.dark().chipTheme.copyWith(
              selectedColor: const Color(0xFF00C29A),
              pressElevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              labelStyle: ThemeData.dark().textTheme.caption,
              backgroundColor:
                  ThemeData.dark().chipTheme.backgroundColor.withOpacity(0.1),
            ),
        sliderTheme: ThemeData.dark().sliderTheme.copyWith(
              inactiveTrackColor: Colors.white,
            ),
      );

  // 外观
  // 0跟随系统，1浅色模式，2深色模式
  final _appearances = [0, 1, 2];

  int get appearancesLength => _appearances.length;

  late int _appearanceIndex;

  int get appearanceIndex => _appearanceIndex;

  /// 外观
  String appearanceLabel(index, context) {
    switch (index) {
      case appearanceFollowSystem:
        return S.of(context).followSystem;
      case appearanceLight:
        return S.of(context).lightModel;
      case appearanceDark:
        return S.of(context).darkModel;
      default:
        return '';
    }
  }

  String currentAppearanceLabel(context) =>
      appearanceLabel(_appearanceIndex, context);
}

const kAppearanceIndex = 'appearanceIndex';
const appearanceFollowSystem = 0;
const appearanceLight = 1;
const appearanceDark = 2;
