import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 阅读时不锁屏
const String kReaderWakelock = 'readerWakelock';
const String kReaderFontSize = 'readerFontSize';
const String kReaderScreenBrightness = 'readerScreenBrightness';
const String kReaderLineHeight = 'readerLineHeight';
const String kReaderDarkModel = 'readerDarkModel';

/// 自动购买付费的章节
const String kAutomaticRenewal = 'automaticRenewal';

/// 阅读器
class ReaderPrefsModel with ChangeNotifier {
  late SharedPreferences _prefs;

  ReaderPrefsModel() {
    _prefs = Persistence.sharedPreferences;

//    _menuIndex = nothing;
    _fontSize = _prefs.getDouble(kReaderFontSize) ?? ReaderConfig.fontSize;
    _screenBrightness = _prefs.getDouble(kReaderScreenBrightness) ??
        ReaderConfig.screenBrightness;
    _wakelock = _prefs.getBool(kReaderWakelock) ?? false;
    _lineHeight =
        _prefs.getDouble(kReaderLineHeight) ?? ReaderConfig.lineHeight;
    _darkModel = _prefs.getBool(kReaderDarkModel) ?? false;
    _automaticRenewal = _prefs.getBool(kAutomaticRenewal) ?? false;

    debugPrint(
        'Reader info: fontSize=$_fontSize,screenBrightness=$_screenBrightness,wakelock=$_wakelock,lineHeight=$_lineHeight,darkModel=_darkModel,automaticRenewal=$_automaticRenewal');
  }

  late bool _wakelock;

  bool get wakelock => _wakelock;

  set wakelock(bool value) {
    _wakelock = value;
    notifyListeners();
    _prefs.setBool(kReaderWakelock, _wakelock);
  }

  late bool _darkModel;

  bool get darkModel => _darkModel;

  set darkModel(bool value) {
    _darkModel = value;
    notifyListeners();
    _prefs.setBool(kReaderDarkModel, _darkModel);
  }

  late double _fontSize;

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
    _prefs.setDouble(kReaderFontSize, _fontSize);
  }

  late double _screenBrightness;

  double get screenBrightness => _screenBrightness;

  set screenBrightness(double value) {
    _screenBrightness = value;
    notifyListeners();
    _prefs.setDouble(kReaderScreenBrightness, _screenBrightness);
  }

  late double _lineHeight;

  double get lineHeight => _lineHeight;

  set lineHeight(double value) {
    _lineHeight = value;
    notifyListeners();
    _prefs.setDouble(kReaderLineHeight, _lineHeight);
  }

  late bool _automaticRenewal;

  bool get automaticRenewal => _automaticRenewal;

  set automaticRenewal(bool value) {
    _automaticRenewal = value;
    notifyListeners();
    _prefs.setBool(kAutomaticRenewal, _automaticRenewal);
  }
}
