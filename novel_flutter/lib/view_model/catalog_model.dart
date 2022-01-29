import 'dart:convert';
import 'dart:io';

import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/model/catalog.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:flutter/foundation.dart';

/// 目录列表
/// 无分页加载
class CatalogModel extends ViewStateModel {
  final String fileUrl; // 文件链接
  final int bookId; // 书籍标识
  final int chapterScore; // 章节价格
  final int chapterFreeCount; // 免费章节数
  final int chapterCnt; // 书籍目录数
  String sort;

  CatalogModel({
    required this.fileUrl,
    required this.bookId,
    required this.chapterScore,
    required this.chapterFreeCount,
    required this.chapterCnt,
    this.sort = sortAsc,
  });

  Future<List<Chapter>> request() async {
    /// 章节付费状态
    List<int>? purchased = await serverAPI.catalogState(bookId: bookId);

//    List<InitialParams> params = await serverAPI.initialParams();
//    int chapterScore;
//    int chapterFreeCount;
//    params.forEach((item) {
//      if (item.name == kChapterScore) {
//        chapterScore = int.parse(item.option);
//      } else if (item.name == kChapterFreeCount) {
//        chapterFreeCount = int.parse(item.option);
//      }
//    });

    /// 目录数据
    List<Chapter>? chapters;
    String fileName = catalogFileName(bookId);
    String path = Persistence.appFilesDir.path + '/' + fileName;
    File file = File(path);

    if (file.existsSync()) {
      final _jsonString = await file.readAsString();
      chapters = Catalog.fromJson(json.decode(_jsonString)).chapters;
    }

    if (chapters == null || chapters.length != chapterCnt) {
      var path = await serverAPI.downloadCatalog(
          fileUrl: fileUrl, bookId: bookId, sort: sort);
      file = File(path);
      final _jsonString = await file.readAsString();
      debugPrint('Book $bookId catalog from remote,url $fileUrl');
      chapters = Catalog.fromJson(json.decode(_jsonString)).chapters;
    } else {
      // 已缓存并且和服务器目录数一致
      debugPrint('Book $bookId catalog from local,path $path');
    }

    /// 前X章节和已购买的章节
    for (var i = 0; i < chapters.length; i++) {
      Chapter item = chapters[i];
      item.price = chapterScore;
      item.have = i < chapterFreeCount || purchased!.contains(item.idx);
    }
    return chapters;
  }
}
