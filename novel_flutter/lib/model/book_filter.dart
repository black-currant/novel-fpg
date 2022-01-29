/// 书籍过滤
class BookFilter {
  static const int bookState = 1;
  static const int bookPrice = 2;
  static const int bookWordCount = 3;

  int id;
  String name;
  bool selected;

  BookFilter(this.id, this.name, this.selected);

  void toggle() => selected = !selected;
}
