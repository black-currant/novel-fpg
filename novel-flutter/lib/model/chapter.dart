/// 书籍章节
class Chapter {
  int? idx;
  String? title;

  Chapter({this.idx, this.title});

  Chapter.fromJson(Map<String, dynamic> json) {
    idx = json['idx'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idx'] = this.idx;
    data['title'] = this.title;
    return data;
  }

  bool have = false; // 默认为付费章节，没有拥有权
  late String content;
  late int price;
  bool selected = false;
  late int index; // 在章节列表中的索引
  Chapter? next;
  Chapter? previous;
  late int bookId;
  late int pageIndex;

  late List<Map<String, int>> pageOffsets; // 章节内容分页

  /// 根据页码返回内容
  String textAtPageIndex(int index) {
    var offset = pageOffsets[index];
    var start = offset['start'] ?? 0;
    return content.substring(start, offset['end']);
  }

  get nextChapterId => next!.idx;

  get preChapterId => previous!.idx;

  /// 章节总页数
  int get pageCount => pageOffsets.length;
}
