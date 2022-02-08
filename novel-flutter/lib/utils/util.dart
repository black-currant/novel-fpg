import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:novel_flutter/app/config.dart';

/// 本应用的工具
class Util {
  /// 章节路径
  static String chapterFile(String url, int chapterId) {
    if (url.startsWith('http')) {
      return url;
    }
    var last = url.lastIndexOf('/');
    var bookDir = url.substring(0, last); // 书籍目录
    String fileUrl = '$resDomain$bookDir/$chapterId.txt';
    debugPrint('Chapter file $fileUrl');
    return fileUrl;
  }

  /// 获取服务器文件资源地址
  static String netFile(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return resDomain + url;
  }

  /// 获取本地图片地址
  static String assetImage(String fileName) {
    return "images/" + fileName;
  }

  /// 获取服务器图片资源地址
  static String netImage(String? url) {
    if (url!.startsWith('http')) {
      return url;
    }
    return resDomain + url;
  }

  /// 返回时间戳
  static String getTimestamp() {
    return '${DateTime.now().millisecondsSinceEpoch}';
  }

  /// 返回MD5摘要消息
  static String generateMd5(String input) {
//    print('before md5: ' + input);
    return md5.convert(utf8.encode(input)).toString();
  }

  static String removeHtmlLabel(String? data) {
    return data!.replaceAll(RegExp('<[^>]+>'), '');
  }

  static double cosine(List<String> originWord, List<String> targetWord) {
    Map<String, List<int>> wordDict = {};
    for (var word in originWord) {
      if (!wordDict.containsKey(word)) {
        List<int> value = [];
        value.add(1);
        value.add(0);
        wordDict[word] = value;
      } else {
        wordDict[word]![0] += 1;
      }
    }

    for (var word in targetWord) {
      if (!wordDict.containsKey(word)) {
        List<int> value = [];
        value.add(0);
        value.add(1);
        wordDict[word] = value;
      } else {
        wordDict[word]![1] += 1;
      }
    }

    double dictNum = 0, originNum = 0, desNum = 0;
    for (var value in wordDict.values) {
      int origin = value[0];
      int des = value[1];
      originNum += origin * origin;
      desNum += des * des;
      dictNum += origin * des;
    }
    return dictNum / sqrt(originNum * desNum);
  }
}

/// 解决日志长度问题
void printWrap(String message) {
  if (Platform.isAndroid && message.length > 4000) {
    for (int i = 0; i < message.length; i += 4000) {
      if (i + 4000 < message.length) {
        debugPrint(message.substring(i, i + 4000));
      } else {
        debugPrint(message.substring(i, message.length));
      }
    }
  } else {
    debugPrint(message);
  }
}

/// 输出中包括更多的粒度和信息。
/// https://flutter.dev/docs/testing/code-debugging
void devLog(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level = 0,
  String name = '',
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!devEnv) return;
  developer.log(message,
      time: time,
      sequenceNumber: sequenceNumber,
      level: level,
      name: name,
      zone: zone,
      error: error,
      stackTrace: stackTrace);
}
