/// 本应用的业务逻辑常量，比如：sharedPreferences的键，接口参数常量值。

const accessTokenHeader = 'Access-Token';

/// sharedPreference'key
///
/// 最近路由的key
String kRecentRoute(int userId) {
  return 'user_${userId}_route';
}

/// 最近阅读章节页码的key
String kRecentPageIndex(int bookId, int userId) {
  return 'user_${userId}_book_${bookId}_page_index';
}

/// 最近阅读章节ID的key
String kRecentChapterId(int bookId, int userId) {
  return 'user_${userId}_book_${bookId}_chapter';
}

/// 最近阅读书籍ID的key
String kRecentBook(int userId) {
  return 'user_${userId}_book';
}

/// localstorage'key
///
/// 本地的书架数据的key
String kBookshelf(int userId) {
  return 'user_${userId}_bookshelf';
}

/// path_provider'key
///
/// 目录文件名
String catalogFileName(int bookId) {
  return 'book_${bookId}_catalog';
}

/// 章节内容文件名
String chapterContentFileName(int bookId, int chapterId) {
  return 'book_${bookId}_chapter_$chapterId';
}

/// 生命周期日历标签
const lifeCycleTag = 'lifeCycle:';
const serverAPITag = 'serverAPI:';
const beforeTag = 'before:';
const afterTag = 'after:';
const testTag = 'test:';

/// 排序状态
const String sortAsc = 'asc'; // 升序
const String sortDesc = 'desc'; // 降序

const String kGotoBookstore = 'goto_bookstore'; // 去书城

/// 书籍完结，结束连载
const int bookStateEnd = 1;

/// url scheme
const String urlSchemeWeChat = 'weixin://'; // 微信

/// 任务ID
const String taskIdCheckIn = 'task.sign.in';
const String taskIdReadingTime = 'task.read.duration';
const String taskIdShare = 'task.daily.share';
const String taskIdFirstRecharge = 'task.first.recharge';

/// 性别
const String genderUnknown = '0';
const String genderMale = '1';
const String genderFemale = '2';

enum Gender { unknown, male, female }

const exceptionCaughtBySelf = 'EXCEPTION CAUGHT BY SELF';
const stackTraceTag = 'STACK TRACE';
