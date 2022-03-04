import 'dart:async';
import 'dart:io';

import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/http_client.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/server_api_code.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/book_type.dart';
import 'package:novel_flutter/model/edit_state.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/model/initial_params.dart';
import 'package:novel_flutter/model/score_flow.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/model/version.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 缓存接口名单
const cacheList = [
  'get_categories',
  'book_list',
  'quest_list',
  'get_favorites',
  'score_flow',
  'sys_config',
];

final ServerAPI serverAPI = ServerAPI();

/// 服务器/后端的接口
class ServerAPI {
  /// 用户登录
  Future<User?> login(
    String account,
    String password,
    String deviceId,
    String deviceName,
    String os,
    String osVersion,
    String appVersion,
    String countryCode,
  ) async {
    final body = {
      'action': 'login',
      'data': {
        'username': account,
        'password': password,
        'deviceid': deviceId,
        'device_mode': deviceName,
        'os': os,
        'os_version': osVersion,
        'app_version': appVersion,
        'country': countryCode,
      },
    };
    Response<Map<String, dynamic>> response =
        await http.post<Map<String, dynamic>>(apiPath, data: body);
    return User.fromJson(response.data!);
  }

  /// 修改用户信息
  Future<bool> updateUserProfile({
    String? photoUrl,
    String? nickname,
    String? gender,
    int? preference,
  }) async {
    int userId = Persistence.sharedPreferences.getInt(kUserId) ?? 0;
    final Map params = {
      'id': userId,
    };
    if (photoUrl != null) params['photourl'] = photoUrl;
    if (nickname != null) params['nickname'] = nickname;
    if (gender != null) params['gender'] = gender;
    if (preference != null) params['preference'] = preference;

    final body = {
      'action': 'mod_info',
      'data': params,
    };
    var response = await http.post(apiPath, data: body);
    return response.statusCode == actionOk;
  }

  /// 查询用户信息
  Future userProfile() async {
    final body = {'action': 'get_info'};
    var response = await http.post<Map>(apiPath, data: body);
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  /// 帐号关联
  Future<bool> accountLinked() async {
    int userId = Persistence.sharedPreferences.getInt(kUserId) ?? 0;
    final body = {
      'action': 'bind_list',
      'data': {
        'id': userId,
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.statusCode == actionOk;
  }

  /// 书籍类型
  Future<List<BookType>> bookTypeList() async {
    final body = {'action': 'get_categories'};
    Response<List<dynamic>> response =
        await http.post<List<dynamic>>(apiPath, data: body);
    return response.data!
        .map<BookType>((map) => BookType.fromJson(map))
        .toList();
  }

  /// 书籍列表
  Future bookList({
    int value = 0,
    String? flag,
    String sort = 'update_time desc',
    int? pageIndex = 1,
    int pageSize = defaultPageSize,
  }) async {
    flag ??= '';
    final body = {
      'action': 'book_list',
      'data': {
        'value': value,
        'flag': flag,
        'order': sort,
        'page': pageIndex, // 页码
        'num': pageSize, // 每页数量
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data.map<Book>((map) => Book.fromJson(map)).toList();
  }

  /// 书籍目录
  Future<String> downloadCatalog(
      {required String fileUrl,
      required int bookId,
      String? sort = 'desc',
      int? pageIndex = 1,
      int pageSize = defaultPageSize}) async {
    String fileName = catalogFileName(bookId);
    String path = Persistence.appFilesDir.path + '/' + fileName;
    await http.download(
      fileUrl,
      path,
    );
    return path;
  }

  /// 书籍目录状态
  /// 是否购买
  Future<List<int>?> catalogState({
    int? bookId,
  }) async {
    final body = {
      'action': 'user_chapter',
      'data': {
        'bid': bookId,
      },
    };
    var response = await http.post(apiPath, data: body);
    List<int> data = [];
    response.data.forEach((element) {
      data.add(element);
    });
    return data;
  }

  /// 书籍章节内容
  Future<List<int>> chapterContent({
    required String fileUrl,
  }) async {
    var response = await http.get(
      fileUrl,
      options: Options(responseType: ResponseType.bytes),
      queryParameters: {'dt': Util.getTimestamp()},
    );
    // response.data是二进制数据。
    return response.data;
  }

  /// 编辑书架
  Future<bool> updateBookshelf(List<int> bookIds, EditState state) async {
    final body = {
      'action': 'set_favorites',
      'data': {
        'bids': bookIds,
        'status': state == EditState.add ? 1 : 0, // 1.添加 0.移出
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.statusCode == actionOk;
  }

  /// 书架列表
  Future<List<Book>> bookshelfList() async {
    final body = {'action': 'get_favorites'};
    var response = await http.post(apiPath, data: body);
    return response.data.map<Book>((map) => Book.fromJson(map)).toList();
  }

  /// 用户激励任务列表
  /// 未登录，uid为空也有数据返回
  Future<List<Incentive>> incentives() async {
    final body = {'action': 'quest_list'};
    var response = await http.post(apiPath, data: body);
    return response.data
        .map<Incentive>((map) => Incentive.fromJson(map))
        .toList();
  }

  /// 领取奖励
  Future<Map<String, dynamic>> receiveReward(taskId) async {
    final body = {
      'action': 'quest_reward',
      'data': {
        'tid': taskId,
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data;
  }

  /// 阅读信息上报
  Future<Map<String, dynamic>> readingReport(int bookId, int duration) async {
    final body = {
      'action': 'read_log',
      'data': {
        'bid': bookId,
        'duration': duration,
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data;
  }

  /// 书币流水列表
  Future scoreFlowList({
    int pageIndex = 1,
    int pageSize = defaultPageSize,
  }) async {
    final body = {
      'action': 'score_flow',
      'data': {
        'page': pageIndex, // 页码
        'num': pageSize, // 每页数量
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data
        .map<ScoreFlow>((map) => ScoreFlow.fromJson(map))
        .toList();
  }

  /// 热搜关键字列表
  /// 后面调试此接口一定要注意得加 errcode和errmsg
  Future searchHotKey({int pageSize = 10}) async {
    final body = {
      'action': 'hot_keywords',
      'data': {
        'num': pageSize,
      },
    };
    var response = await http.post(apiPath, data: body);
    List<String> data = [];
    response.data.forEach((element) {
      data.add(element);
    });
    return data;

//    var response = await http.post(apiPath, data: body);
//    return response.data
//        .map<SearchHotKey>((item) => SearchHotKey.fromMap(item))
//        .toList();
  }

  /// 搜索结果
  Future searchResult({
    String keyword = '',
    int pageIndex = 1,
    int pageSize = defaultPageSize,
  }) async {
    final body = {
      'action': 'book_list',
      'data': {
        'keywords': keyword,
        'page': pageIndex, // 页码
        'num': pageSize, // 每页数量
      },
    };
    var response = await http.post(apiPath, data: body);
    List<Book> books =
        response.data.map<Book>((map) => Book.fromJson(map)).toList();
    if (books.isNotEmpty) {
      /// 按词向量距离算法排序，感觉这部分逻辑应该放服务器。
      List<String> targetWord = [keyword];
      for (var book in books) {
        List<String> originWord = [];
        originWord.add('${book.title}');
        originWord.add('${book.author}');
        double weight = Util.cosine(originWord, targetWord);
        debugPrint('book ${book.title}, weight $weight');
        book.weight = weight as int?;
      }
      books.sort((left, right) => right.weight!.compareTo(left.weight!));
    }
    return books;
  }

  /// 应用升级
  Future<Version> upgrade() async {
    final body = {
      'action': 'sys_config',
    };
    var response = await http.post(apiPath, data: body);
    var data = response.data
        .map<InitialParams>((map) => InitialParams.fromJson(map))
        .toList();
    var key = Platform.isIOS ? kIOSVer : kAndroidVer;
    var versionCode = 0;
    var forced = 0;
    data.forEach((item) {
      if (item.name == key) {
        versionCode = int.parse(item.option);
      } else if (item.name == kForceUpdate) {
        forced = int.parse(item.option);
      }
    });
    Version version = Version(
        versionCode: versionCode,
        versionName: '',
        desc: '',
        forced: forced,
        downloadUrl: '');
    return version;
  }

  /// 上报阅读时长
  Future<Map<String, dynamic>> readingTimeReport(
      int bookId, int duration) async {
    final body = {
      'action': 'read_log',
      'data': {
        'bid': bookId,
        'duration': duration,
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data;
  }

  /// 消耗书币
  /// 购买章节
  Future<Map<String, dynamic>> consumeScore(
      int chapterId, int bookId, int price) async {
    final body = {
      'action': 'buy_chapter',
      'data': {
        'bid': bookId,
        'cid': chapterId,
        'score': price,
      },
    };
    var response = await http.post(apiPath, data: body);
    return response.data;
  }

  /// 自定义事件统计/埋码/埋点/事件追踪/行为追踪
  Future actionTrack(String action) async {
    int userId = Persistence.sharedPreferences.getInt(kUserId) ?? 0;
    final body = {
      'action': action,
      'data': {
        'id': userId,
      },
    };
    await http.post(reportPath, data: body);
    // 不需要返回值
  }

  /// 获取初始化参数
  Future<List<InitialParams>> initialParams() async {
    final body = {
      'action': 'sys_config',
    };
    var response = await http.post(apiPath, data: body);
    return response.data
        .map<InitialParams>((map) => InitialParams.fromJson(map))
        .toList();
  }
}
