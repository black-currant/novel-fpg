import 'dart:io';
import 'dart:typed_data';

import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:html/parser.dart' as html;
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';

/// 章节内容
class ChapterModel extends ViewStateModel {
  final String fileUrl;
  final int bookId;
  final int chapterId;
  final String textIndent = '　　'; // 中文首行缩进，全角符号
  final String paraDivider = '\n　　'; // 段落分频器

  ChapterModel({
    required this.fileUrl,
    required this.bookId,
    required this.chapterId,
  });

  Future<String> request() async {
    String fileName = chapterContentFileName(bookId, chapterId);
    String path = Persistence.appFilesDir.path + '/' + fileName;
    File file = File(path);

    List<int> bytes;
    if (file.existsSync()) {
      debugPrint('Chapter id $chapterId content from local,path $path.');
//      return file.readAsStringSync();
      bytes = file.readAsBytesSync();
    } else {
      debugPrint('Chapter id $chapterId content from remote,url $fileUrl');
      bytes = await serverAPI.chapterContent(
        fileUrl: fileUrl,
      );
      // 缓存章节内容
      file.writeAsBytes(bytes);
    }

    const blockSize = 16;
    final key = encrypt.Key.fromUtf8(chapterKey);
    // debugPrint('key $key' + key.toString());
    // debugPrint('key ${key.base16}');
    // debugPrint('key ${key.base64}');

    final ivBytes = Uint8List(blockSize)..setRange(0, blockSize, bytes);
    final iv = IV(ivBytes);
    // debugPrint('iv $iv');
    // debugPrint('iv ${iv.base16}');
    // debugPrint('iv ${iv.base64}');

    final cipherLen = bytes.length - blockSize;
    final cipherBytes = Uint8List(cipherLen)
      ..setRange(0, cipherLen, bytes, blockSize);
    // devLog('bytes $cipherBytes');
    final encrypted = Encrypted(cipherBytes);

    // 构建编码器
    final crypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    // 解密
    var content = crypter.decrypt(encrypted, iv: iv);
    // devLog('Chapter content after decrypted$content');
    content = typesetting(content);
    // devLog('Chapter content after typesetting$content');
    return content;
  }

  /// 排版
  String typesetting(String original) {
    if (original.contains(r'<p>')) {
      original = pTag(original);
    } else if (original.contains(r'<br />')) {
      original = brTag(original);
    }

    // 如果原文存在小写字母o，替换为中文句号，部分书籍存在此问题
    if (original.contains(r'o')) {
      original = original.replaceAll(RegExp(r'o'), '。');
    }

    original = html.parse(original).body!.text; // 移除HTML标签，同时会包空格移除
    original = handleStartEnd(original);

    return original;
  }

  /// 处理HTML字符串的p标签
  /// p标签替换为首行缩进，/p标签替换为换行符
  String pTag(String original) {
    original = original.replaceAll(RegExp(r'<p>'), '');
    original = original.replaceAll(RegExp(r'</p>'), paraDivider);
    return original;
  }

  /// 处理HTML字符串的<br />&nbsp;标签
  /// br标签替换为换行符，&nbsp;替换为' ' * 2
  String brTag(String original) {
    /// 处理各种情况都处理为regExp
    var regExp = RegExp(r'<br />&nbsp;&nbsp;&nbsp;&nbsp;');
    var regExp2 =
        RegExp(r'<br />&nbsp;&nbsp;&nbsp;&nbsp;<br />&nbsp;&nbsp;&nbsp;&nbsp;');
    if (original.contains(regExp2)) {
      original = original.replaceAll(regExp2, regExp.pattern);
    }

    var regExp14 = RegExp(r'<br /><br />');
    var regExp3 = RegExp(r'<br /><br />        ');
    var regExp4 = RegExp(r'<br /><br />    ');
    var regExp5 = RegExp(r'<br /><br /><br /><br />    ');
    if (original.contains(regExp5)) {
      original = original.replaceAll(regExp5, regExp14.pattern);
    } else if (original.contains(regExp3)) {
      original = original.replaceAll(regExp3, regExp14.pattern);
    } else if (original.contains(regExp4)) {
      original = original.replaceAll(regExp4, regExp14.pattern);
    }

    var regExp15 = RegExp(r'<br /> ');
    var regExp6 = RegExp(r'<br />    ');
    var regExp8 = RegExp(r'<br />    <br />    ');
    var regExp10 = RegExp(r'<br />    <br />        ');
    var regExp7 = RegExp(r'<br />　　');
    var regExp13 = RegExp(r'<br />　　<br />　　');
    var regExp9 = RegExp(r'<br />　　<br />　　    ');
    var regExp11 = RegExp(r'<br />　　<br />　　<br />　　<br />　　    ');
    var regExp12 = RegExp(r'<br />　　    <br />　　        ');
    if (original.contains(regExp11)) {
      original = original.replaceAll(regExp11, regExp15.pattern);
    } else if (original.contains(regExp10)) {
      original = original.replaceAll(regExp10, regExp15.pattern);
    } else if (original.contains(regExp8)) {
      original = original.replaceAll(regExp8, regExp15.pattern);
    } else if (original.contains(regExp7)) {
      original = original.replaceAll(regExp7, regExp15.pattern);
    } else if (original.contains(regExp6)) {
      original = original.replaceAll(regExp6, regExp15.pattern);
    } else if (original.contains(regExp13)) {
      original = original.replaceAll(regExp13, regExp15.pattern);
    } else if (original.contains(regExp9)) {
      original = original.replaceAll(regExp9, regExp15.pattern);
    } else if (original.contains(regExp12)) {
      original = original.replaceAll(regExp12, regExp15.pattern);
    }

    if (original.contains(regExp)) {
      original = original.replaceAll(regExp, paraDivider);
    } else if (original.contains(regExp14)) {
      original = original.replaceAll(regExp14, paraDivider);
    } else if (original.contains(regExp15)) {
      original = original.replaceAll(regExp15, paraDivider);
    }
    return original;
  }

  /// 处理章节内容的头和尾
  /// 移除末尾的换行符，解决章节末尾空白页问题
  String handleStartEnd(String original) {
    while (true) {
      original = original.trim();

      if (original.startsWith('\n')) {
        original = original.substring(1);
      }

      if (original.endsWith('\n')) {
        original = original.substring(0, original.length - 2);
      } else {
        break;
      }
    }

    /// 处理开头第一段的首行缩进
    original = textIndent + original;
    return original;
  }
}
