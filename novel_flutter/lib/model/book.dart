import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book_state.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/utils/util.dart';

/// 书籍信息
class Book {
  String? author;
  String? catalogLink;
  String? category;
  int? chapterCnt;
  int? chapterCost;
  String? createTime;
  int? flag;
  int? free;
  int? freeChapterCnt;
  int? id;
  String? image;
  String? intro;
  String? recentChapter;
  int? status;
  String? tags;
  String? title;
  String? updateTime;
  int? value;
  int? weight;
  int? wordsCnt;

  Book(
      {this.author,
      this.catalogLink,
      this.category,
      this.chapterCnt,
      this.chapterCost,
      this.createTime,
      this.flag,
      this.free,
      this.freeChapterCnt,
      this.id,
      this.image,
      this.intro,
      this.recentChapter,
      this.status,
      this.tags,
      this.title,
      this.updateTime,
      this.value,
      this.weight,
      this.wordsCnt});

  Book.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    catalogLink = json['catalog_link'];
    category = json['category'];
    chapterCnt = json['chapter_cnt'];
    chapterCost = json['chapter_cost'];
    createTime = json['create_time'];
    flag = json['flag'];
    free = json['free'];
    freeChapterCnt = json['free_chapter_cnt'];
    id = json['id'];
    image = json['image'];
    intro = json['intro'];
    recentChapter = json['recent_chapter'];
    status = json['status'];
    tags = json['tags'];
    title = json['title'];
    updateTime = json['update_time'];
    value = json['value'];
    weight = json['weight'];
    wordsCnt = json['words_cnt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author'] = this.author;
    data['catalog_link'] = this.catalogLink;
    data['category'] = this.category;
    data['chapter_cnt'] = this.chapterCnt;
    data['chapter_cost'] = this.chapterCost;
    data['create_time'] = this.createTime;
    data['flag'] = this.flag;
    data['free'] = this.free;
    data['free_chapter_cnt'] = this.freeChapterCnt;
    data['id'] = this.id;
    data['image'] = this.image;
    data['intro'] = this.intro;
    data['recent_chapter'] = this.recentChapter;
    data['status'] = this.status;
    data['tags'] = this.tags;
    data['title'] = this.title;
    data['update_time'] = this.updateTime;
    data['value'] = this.value;
    data['weight'] = this.weight;
    data['words_cnt'] = this.wordsCnt;
    return data;
  }

  bool selected = false;

  /// 10000 to 1万
  String getWordCountText(BuildContext context) {
    String text = "";
    if (wordsCnt == null || wordsCnt! <= 0) {
      text = "";
    } else if (wordsCnt! < 10000) {
      text = wordsCnt.toString() + S.of(context).word;
    } else {
      // 将数字转换成万
      double count = wordsCnt! / 10000;
      text = count.toStringAsFixed(2) + S.of(context).millionWords;
    }
    return text;
  }

  String getCover() {
    if (image == null) return '';
    return Util.netImage(image);
  }

  String getBookFlagText(BuildContext context) {
    return flag == BookState.serial
        ? S.of(context).bookSerial
        : S.of(context).bookEnd;
  }

  bool get finished => flag == bookStateEnd;

  toggleSelect() => selected = !selected;
}
