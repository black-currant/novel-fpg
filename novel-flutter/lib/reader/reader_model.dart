import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:novel_flutter/reader/reader_prefs_model.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:novel_flutter/view_model/reading_time_report_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 阅读器
class ReaderModel with ChangeNotifier {
  static const int nothing = 0;
  static const int menu = 1;
  static const int catalog = 2;
  static const int prefs = 3;

  final Book book;
  final Chapter chapter;
  late SharedPreferences _prefs;

  ReaderModel({required this.book, required this.chapter}) {
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

    debugPrint('textScaleFactor ${ScreenUtil.textScaleFactor}');

    debugPrint('Reader info:' +
        'bookId:' +
        book.id.toString() +
        ',chapterId:' +
        chapter.idx.toString() +
        ',pageIndex:' +
        chapter.pageIndex.toString() +
        ',fontSize:' +
        _fontSize.toString() +
        ',screenBrightness:' +
        _screenBrightness.toString() +
        ',wakelock:' +
        _wakelock.toString() +
        ',lineHeight:' +
        _lineHeight.toString() +
        ',darkModel:' +
        _darkModel.toString() +
        ',automaticRenewal:' +
        _automaticRenewal.toString());
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

  double get fontSize => _fontSize; // / ScreenUtil.textScaleFactor;

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

  late int _menuIndex;

  int get menuIndex => _menuIndex;

  set menuIndex(int value) {
    _menuIndex = value;
    notifyListeners();
  }

  late bool _automaticRenewal;

  bool get automaticRenewal => _automaticRenewal;

  set automaticRenewal(bool value) {
    _automaticRenewal = value;
    notifyListeners();
    _prefs.setBool(kAutomaticRenewal, _automaticRenewal);
  }

  void refreshAutomaticRenewal() {
    _automaticRenewal = _prefs.getBool(kAutomaticRenewal) ?? false;
  }

  void refreshDarkModel() {
    _darkModel = _prefs.getBool(kReaderDarkModel) ?? false;
  }

  Future readingTimeReport(UserModel userModel, IncentivesModel incentivesModel,
      int duration) async {
    // 上报阅读时长
    if (duration < 60000) return true; // 小于一分钟不上报
    String temp = (duration / 60000).toString();
    // 取整，单位分钟
    int endIndex = temp.indexOf('.');
    temp = temp.substring(0, endIndex);
    duration = int.parse(temp);
    debugPrint('Reading time duration $duration minute');
    ReadingTimeReportModel model = ReadingTimeReportModel(userModel);
    await model.request(book.id!, duration);
    // 刷新激励任务数据
    await incentivesModel.initData();
    return true;
  }
}
