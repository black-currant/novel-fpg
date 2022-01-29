import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/book_price.dart';
import 'package:novel_flutter/model/book_word_count.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';
import 'package:html/parser.dart' as html;

/// 书籍列表
class BookListModel extends ViewStateRefreshListModel<Book> {
  int value;
  String? flag; // 完结状态
  String? price; // 价格
  String? wordCount; // 字数
  String sort; // 排序
  int pageSize; // 每页个数

  BookListModel({
    this.value = 0,
    this.flag = '',
    this.price = '',
    this.wordCount = '',
    this.sort = 'update_time desc',
    this.pageSize = defaultPageSize,
  });

  void setWordCount(String value) => wordCount = value;

  void setBookState(String value) => flag = value;

  void setBookPrice(String value) => price = value;

  @override
  Future<List<Book>> loadData({required int pageNum}) async {
    List<Book> data = await serverAPI.bookList(
        pageIndex: pageNum,
        value: value,
        flag: flag,
        sort: sort,
        pageSize: pageSize);
    if (data.isEmpty) return data;

    // 本地筛选条件
    if (price != null) {
      if (price == BookPrice.member.toString()) {
        data.removeWhere((item) {
          return item.free == 1;
        });
      } else if (price == BookPrice.free.toString()) {
        data.removeWhere((item) {
          return item.free != 1;
        });
      }
    }
    if (wordCount != null) {
      // 字数过滤
      if (wordCount == BookWordCount.less20w.toString()) {
        data.removeWhere((item) {
          return item.wordsCnt! > 200000;
        });
      } else if (wordCount == BookWordCount.between20wTo50w.toString()) {
        data.removeWhere((item) {
          return item.wordsCnt! < 200000 || item.wordsCnt! > 500000;
        });
      } else if (wordCount == BookWordCount.between50wTo100w.toString()) {
        data.removeWhere((item) {
          return item.wordsCnt! < 500000 || item.wordsCnt! > 1000000;
        });
      } else if (wordCount == BookWordCount.between100wTo200w.toString()) {
        data.removeWhere((item) {
          return item.wordsCnt! < 1000000 || item.wordsCnt! > 2000000;
        });
      } else if (wordCount == BookWordCount.over200w.toString()) {
        data.removeWhere((item) {
          return item.wordsCnt! <= 2000000;
        });
      }
    }

    /// 去HTML标签
    for (var element in data) {
      element.intro = html.parse(element.intro).body!.text;
    }
    return data;
  }
}
