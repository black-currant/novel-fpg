import 'package:novel_flutter/utils/util.dart';

/// 书记类型
class BookType {
  int? bookCnt;
  String? category;
  int? code;
  int? id;
  String? image;
  int? value;

  BookType(
      {this.bookCnt,
      this.category,
      this.code,
      this.id,
      this.image,
      this.value});

  BookType.fromJson(Map<String, dynamic> json) {
    bookCnt = json['book_cnt'];
    category = json['category'];
    code = json['code'];
    id = json['id'];
    image = json['image'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['book_cnt'] = this.bookCnt;
    data['category'] = this.category;
    data['code'] = this.code;
    data['id'] = this.id;
    data['image'] = this.image;
    data['value'] = this.value;
    return data;
  }

  String getCover() => Util.netImage(image);
}
