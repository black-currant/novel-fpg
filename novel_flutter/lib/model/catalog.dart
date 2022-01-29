import 'package:novel_flutter/model/chapter.dart';

/// 书籍目录
class Catalog {
  late int id;
  late String title;
  late String author;
  late List<Chapter> chapters;
  late String recentChapter;
  late int chapterCnt;
  late String updateTime;

  Catalog(
      {required this.id,
      required this.title,
      required this.author,
      required this.chapters,
      required this.recentChapter,
      required this.chapterCnt,
      required this.updateTime});

  Catalog.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    author = json['author'];
    if (json['chapters'] != null) {
      chapters = <Chapter>[];
      json['chapters'].forEach((v) {
        chapters.add(new Chapter.fromJson(v));
      });
    }
    recentChapter = json['recent_chapter'];
    chapterCnt = json['chapter_cnt'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['author'] = this.author;
    if (this.chapters != null) {
      data['chapters'] = this.chapters.map((v) => v.toJson()).toList();
    }
    data['recent_chapter'] = this.recentChapter;
    data['chapter_cnt'] = this.chapterCnt;
    data['update_time'] = this.updateTime;
    return data;
  }
}
