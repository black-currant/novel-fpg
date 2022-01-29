import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/model/book_channel.dart';
import 'package:novel_flutter/model/book_type.dart';
import 'package:novel_flutter/provider/view_state_refresh_list_model.dart';

/// 书籍类型列表
class BookTypesModel extends ViewStateRefreshListModel<BookType> {
  final int channelId; // 男女频道
  final String languageTag;

  BookTypesModel({
    required this.channelId,
    required this.languageTag,
  });

  @override
  Future<List<BookType>> loadData({required int pageNum}) async {
    if (pageNum > ViewStateRefreshListModel.pageNumFirst) {
      return [];
    }

    List<BookType> data = await serverAPI.bookTypeList();
    if (data.isEmpty) return data;
    // 接口已经不区分channelId
    if (channelId != BookChannel.all) {
      data.removeWhere((item) => item.value != channelId);
    }
    return data;
  }
}
