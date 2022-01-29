import 'dart:convert';
import 'dart:io';

import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/catalog.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';
import 'package:flutter/material.dart';

/// 目录列表
/// 分页加载
/// 连载书籍的目录，判断是否需要更新缓存
class CatalogListModel extends ViewStateRefreshListModel {
  final String fileUrl; // 文件链接
  final int bookId; // 书籍标识
  final int chapterPrice; // 章节价格
  final int chapterFreeCount; // 免费章节数
  final int chapterCnt; // 书籍目录数
  String? sort;
  List<Chapter>? chapters;

  CatalogListModel({
    required this.fileUrl,
    required this.bookId,
    required this.chapterPrice,
    required this.chapterFreeCount,
    required this.chapterCnt,
    this.sort,
  }) {
    pageSize = 100; // 特殊情况，每次加载100条
  }

  @override
  Future<List<Chapter>> loadData({required int pageNum}) async {
    if (chapters == null || chapters!.isEmpty) {
      /// 目录付费状态
      List<int>? purchased =
          await serverAPI.catalogState(bookId: bookId); // 已经购买的章节

      /// 目录数据
      String fileName = catalogFileName(bookId);
      String path = Persistence.appFilesDir.path + '/' + fileName;
      File file = File(path);
      if (file.existsSync()) {
        final _jsonString = await file.readAsString();
        chapters = Catalog.fromJson(json.decode(_jsonString)).chapters;
      }

      if (chapters == null || chapters!.length != chapterCnt) {
        var path = await serverAPI.downloadCatalog(
            fileUrl: fileUrl,
            bookId: bookId,
            sort: sort,
            pageIndex: pageNum,
            pageSize: pageSize);
        file = File(path);
        final _jsonString = await file.readAsString();
        debugPrint('Book $bookId catalog from remote,url $fileUrl');
        chapters = Catalog.fromJson(json.decode(_jsonString)).chapters;
      } else {
        // 已缓存并且和服务器目录数一致
        debugPrint('Book $bookId catalog from local,path $path');
      }

      /// 前X章节和已购买的章节
      for (var i = 0; i < chapters!.length; i++) {
        Chapter item = chapters![i];
        item.price = chapterPrice;
        item.have = i < chapterFreeCount || purchased!.contains(item.idx);
      }
    }
    int pageIndex = pageNum; // 从零开始
    int startIndex = pageIndex * pageSize;
    int endIndex = startIndex + pageSize;
    int _chapterCount = chapterCount;
    endIndex = endIndex > _chapterCount ? _chapterCount : endIndex;
    return chapters!.sublist(startIndex, endIndex);
  }

  void toggleSort() {
    sort = sort == sortAsc ? sortDesc : sortAsc;
    chapters = chapters!.reversed.toList();
    refresh();
  }

  bool isAscSort() {
    return sort == sortAsc;
  }

  int get chapterCount => chapters!.length;

  @override
  void dispose() {
    super.dispose();
    chapters = [];
  }
}
