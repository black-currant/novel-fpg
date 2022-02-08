import 'dart:async';

import 'package:novel_flutter/app/application.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/insufficient_balance_dialog.dart';
import 'package:novel_flutter/reader/purchase_chapter_dialog.dart';
import 'package:novel_flutter/reader/reader_catalog.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:novel_flutter/reader/reader_menu.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:novel_flutter/reader/reader_prefs_bar.dart';
import 'package:novel_flutter/reader/reader_utils.dart';
import 'package:novel_flutter/reader/reader_view.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/catalog_model.dart';
import 'package:novel_flutter/view_model/chapter_model.dart';
import 'package:novel_flutter/view_model/consume_score_model.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

enum PageJumpType { stay, firstPage, lastPage }

/// 阅读器
/// 阅读状态：全屏
/// 菜单和目录状态：有底部系统栏，有顶部系统栏
///
///
/// 阅读时长计算方法：
/// 开始计时，进入页面，从后台返回前台
/// 上报，退出页面，切换到后台
class ReaderScene extends StatefulWidget {
  final Book book;
  final Chapter chapter;

  const ReaderScene({
    Key? key,
    required this.book,
    required this.chapter,
  }) : super(key: key);

  @override
  ReaderSceneState createState() => ReaderSceneState();
}

class ReaderSceneState extends State<ReaderScene>
    with RouteAware, WidgetsBindingObserver {
  late PageController _pageController;
  int pageIndex = 0; // 当前章节的分页索引，也是界面显示的页码-1

  double topSafeHeight = 0; // 安全高度，刘海屏幕
  double bottomSafeHeight = 0;

  List<Chapter> chapters = <Chapter>[];
  Chapter? preChapter;
  Chapter? currentChapter;
  Chapter? nextChapter;

  late ReaderModel readerModel;
  late int startTime; // 开始阅读时间，单位毫秒

  bool menuVisible = false;
  bool catalogVisible = false;
  bool prefsVisible = false;

  late double contentHeight;
  late double contentWidth;

  void initReader() async {
    // 设置系统栏可见性
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: []);

    // 不延迟的话，安卓获取到的topSafeHeight是错的。
    await Future.delayed(const Duration(milliseconds: 100), () {});
    topSafeHeight = ScreenUtil.topSafeHeight;
    debugPrint('Top safe height $topSafeHeight px');
    bottomSafeHeight = ScreenUtil.bottomSafeHeight;
    debugPrint('Bottom safe height $bottomSafeHeight px');
    // 计算正文区域宽高
    contentHeight = ScreenUtil.height -
        topSafeHeight -
        ReaderConfig.topOffset -
        bottomSafeHeight -
        ReaderConfig.bottomOffset -
        20;

    contentWidth =
        ScreenUtil.width - ReaderConfig.leftOffset - ReaderConfig.rightOffset;

    Wakelock.toggle(enable: !readerModel.wakelock);

    startTimer();

    saveRecentRoute(RouteName.reader);

    CatalogModel model = CatalogModel(
        fileUrl: Util.netFile(widget.book.catalogLink!),
        bookId: widget.book.id!,
        chapterScore: widget.book.chapterCost!,
        chapterFreeCount: widget.book.freeChapterCnt!,
        chapterCnt: widget.book.chapterCnt!);
    chapters = await model.request();
    Chapter target = chapters[0]; // 默认从第一章开始
    if (widget.chapter.idx != null) {
      for (var i = 0; i < chapters.length; i++) {
        Chapter item = chapters[i];
        if (item.idx == widget.chapter.idx) {
          target = item;
          break;
        }
      }
    }
    resetContent(target, PageJumpType.stay);
  }

  @override
  void initState() {
    debugPrint('$lifeCycleTag $this initState.');
    super.initState();

    readerModel = ReaderModel(book: widget.book, chapter: widget.chapter);

    // 注册前后台切换监听
    WidgetsBinding.instance!.addObserver(this);

    _pageController =
        PageController(keepPage: false, initialPage: widget.chapter.pageIndex);
//    _pageController.addListener(onScrollListener);

    initReader();
  }

  @override
  void didChangeDependencies() {
    debugPrint('$lifeCycleTag didChangeDependencies.');
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('$lifeCycleTag didChangeAppLifecycleState,state $state');
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
        startTimer();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        pauseReader();
        break;
      case AppLifecycleState.detached: //
        break;
    }
  }

  @override
  void deactivate() {
    debugPrint('$lifeCycleTag $this deactivate.');
    super.deactivate();
    // 界面的返回按钮和Android物理返回键都会走这里，而且context还未销毁。
    exitReader();
  }

  @override
  void dispose() {
    debugPrint('$lifeCycleTag $this dispose.');

    _pageController.dispose();
    routeObserver.unsubscribe(this);

    readerModel.dispose();

    // 注销前后台切换监听
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didPop() {
    debugPrint('$lifeCycleTag $this didPop.');
  }

  Future pauseReader() async {
    endTimer();
    saveReadRecords();
  }

  Future exitReader() async {
    endTimer();
    saveReadRecords();

    saveRecentRoute('');

    // 如果开启了屏幕常亮，在退出阅读器时要关闭
    if (await Wakelock.enabled) {
      Wakelock.disable();
    }

    // 设置系统栏可见性
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }

  Future saveReadRecords() async {
    // 保存阅读记录，x书x章x页?
    int? userId = Persistence.sharedPreferences.getInt(kUserId);
    String key = kRecentBook(userId!);
    await Persistence.localStorage.setItem(key, widget.book);
    key = kRecentChapterId(widget.book.id!, userId);
    int value = currentChapter!.idx!; // 未加载出内容，然后退出阅读器，这种情况下currentChapter为空。
    bool result1 = await Persistence.sharedPreferences.setInt(key, value);
    key = kRecentPageIndex(widget.book.id!, userId);
    value = (preChapter != null ? preChapter!.pageCount : 0) + pageIndex;
    bool result2 = await Persistence.sharedPreferences.setInt(key, value);
    return Future.value(result1 && result2);
  }

  /// 开始计时
  void startTimer() {
    startTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('Reading time start $startTime milliseconds.');
  }

  /// 结束计时
  Future endTimer() async {
    int endTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint('Reading time end $endTime milliseconds.');
    int duration = endTime - startTime;
    debugPrint('Reading time duration $duration milliseconds.');
    IncentivesModel incentivesModel = Provider.of(context, listen: false);
    UserModel userModel = Provider.of(context, listen: false);
    readerModel.readingTimeReport(userModel, incentivesModel, duration);
  }

  /// 每隔一分钟上报一次阅读时长
  /// 解决切换后台结束应用后无法统计时长问题
  Stream readingTimeReportLoop() async* {}

  /// 重置PageView的内容
  void resetContent(Chapter chapter, PageJumpType jumpType) async {
    currentChapter = await fetchContent(chapter);

    if (currentChapter!.previous != null) {
      preChapter = await fetchContent(currentChapter!.previous!);
    } else {
      preChapter = null;
    }
    if (currentChapter!.next != null) {
      nextChapter = await fetchContent(currentChapter!.next!);
    } else {
      nextChapter = null;
    }
    if (jumpType == PageJumpType.firstPage) {
      pageIndex = 0;
    } else if (jumpType == PageJumpType.lastPage) {
      pageIndex = currentChapter!.pageCount - 1;
    }
    // 跳到指定页
    if (jumpType != PageJumpType.stay) {
      _pageController.jumpToPage(
          (preChapter != null ? preChapter!.pageCount : 0) + pageIndex);
    }
    setState(() {});
  }

  /// 检查章节所有权
  /// silentRenewal 静默续约
  Future<bool> checkChapterProperty(Chapter chapter, bool silentRenewal) async {
    if (chapter.have) return Future.value(true);
    // 判断书币余额
    int score = Provider.of<UserModel>(context, listen: false).user.score!;
    bool insufficient = score < chapter.price; // 余额不足
    if (insufficient) {
      if (silentRenewal) {
        return Future.value(false);
      }
      await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, state) {
              return InsufficientBalanceDialog(chapter: chapter);
            });
          });
      return Future.value(false);
    }
    if (readerModel.automaticRenewal) {
      if (!silentRenewal) {
        showLoadingDialog(context, S.of(context).purchasingChapter);
      }
      // debugPrint('Consume score processing, Please do not repeat the request.');
      ConsumeScoreModel model =
          ConsumeScoreModel(Provider.of<UserModel>(context, listen: false));
      bool successful =
          await model.request(chapter.idx!, chapter.bookId, chapter.price);
      if (!silentRenewal) {
        closeLoadingDialog(context);
      }
      if (!successful && !silentRenewal) {
        showToast(S.of(context).failedPurchase);
      }
      chapter.have = successful;
      return Future.value(successful);
    } else {
      bool purchased = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, state) {
                  return PurchaseChapterDialog(
                    chapter: chapter,
                    setState: state,
                  );
                });
              }) ??
          false;
      chapter.have = purchased;
      readerModel.refreshAutomaticRenewal();
      return Future.value(purchased);
    }
  }

  /// 到达上一章节
  void arrivePreviousChapter() async {
    debugPrint('Coming to the previous chapter.');

    bool right = await checkChapterProperty(preChapter!, false);
    debugPrint('Check chapter ${preChapter!.title} property $right.');
    if (!right) {
      // 购买失败，回到原页面
      var back = preChapter!.pageCount;
      _pageController.jumpToPage(back);
      return;
    }

    debugPrint('Change to the fresh previous chapter.');
    nextChapter = currentChapter;
    currentChapter = preChapter!;
    preChapter = null;
    pageIndex = currentChapter!.pageCount - 1;
    _pageController.jumpToPage(currentChapter!.pageCount - 1);
    fetchFreshPreviousChapter(currentChapter!.previous!);
    setState(() {});
    debugPrint(
        'Arrived the previous chapter successfully,chapter ${currentChapter!.title}.');
  }

  /// 到达下一章节
  void arriveNextChapter() async {
    debugPrint('Coming to the next chapter.');

    bool right = await checkChapterProperty(nextChapter!, false);
    debugPrint('Check chapter ${nextChapter!.title} property $right.');
    if (!right) {
      // 购买失败，回到原页面
      var back = (preChapter != null ? preChapter!.pageCount : 0) +
          currentChapter!.pageCount -
          1;
      _pageController.jumpToPage(back);
      return;
    }

    debugPrint('Change to the fresh next chapter.');
    preChapter = currentChapter;
    currentChapter = nextChapter!;
    nextChapter = null;
    pageIndex = 0;
    _pageController.jumpToPage(preChapter!.pageCount);
    fetchFreshNextChapter(currentChapter!.next!); // 异步方法
    debugPrint(
        'Arrived the next chapter successfully,chapter ${currentChapter!.title}.');
    setState(() {});
  }

//  void onScrollListener() {
//    debugPrint('onScrollListener.');
//
//    var pageOffset = _pageController.offset / ScreenUtil.width;
//    debugPrint('$pageOffset pages turned.'); // 翻了pageOffset页
//
//    var nextChapterPage = currentChapter.pageCount +
//        (preChapter != null ? preChapter.pageCount : 0);
//
//    /// 保持前中后三个章节顺序
//    if (nextChapter != null && pageOffset >= nextChapterPage) {
//      arriveNextChapter();
//    } else if (preChapter != null && pageOffset <= preChapter.pageCount - 1) {
//      arrivePreviousChapter();
//    }
//  }

  /// 获取新的上一章节
  void fetchFreshPreviousChapter(Chapter? chapter) async {
    if (preChapter != null || chapter == null) {
      debugPrint('Not have fresh previous chapter.');
      return;
    }
    preChapter = await fetchContent(chapter);
    _pageController.jumpToPage(preChapter!.pageCount + pageIndex);
    setState(() {});
    if (readerModel.automaticRenewal) {
      bool right = await checkChapterProperty(preChapter!, true);
      debugPrint('Check chapter ${preChapter!.title} property $right.');
    }
  }

  /// 获取新的下一章节
  void fetchFreshNextChapter(Chapter? chapter) async {
    if (nextChapter != null || chapter == null) {
      debugPrint('Not have fresh next chapter.');
      return;
    }
    nextChapter = await fetchContent(chapter);
    setState(() {});
    if (readerModel.automaticRenewal) {
      bool right = await checkChapterProperty(nextChapter!, true);
      debugPrint('Check chapter ${nextChapter!.title} property $right.');
    }
  }

  /// 获取章节内容
  Future<Chapter> fetchContent(Chapter chapter) async {
    ChapterModel model = ChapterModel(
        fileUrl: Util.chapterFile(widget.book.catalogLink!, chapter.idx!),
        bookId: widget.book.id!,
        chapterId: chapter.idx!);
    var content = await model.request();
    var index = chapters.indexOf(chapter); // 章节索引
    var nextChapter = index + 1 < chapters.length ? chapters[index + 1] : null;
    var preChapter = index - 1 >= 0 ? chapters[index - 1] : null;
    // 完善章节数据
    chapter.content = content;
    chapter.next = nextChapter;
    chapter.previous = preChapter;
    chapter.index = index;
    chapter.bookId = widget.book.id!;
    chapter.price = widget.book.chapterCost!;
    // 计算章节分页
    chapter.pageOffsets = ReaderUtils.getPageOffsets(
        chapter.content,
        contentWidth,
        contentHeight,
        readerModel.fontSize,
        readerModel.lineHeight);

    debugPrint(
        'Fetched content successful. Chapter id ${chapter.idx}, title ${chapter.title}, page count ${chapter.pageCount}, have ${chapter.have}.');
    return chapter;
  }

  void previousPage() {
    if (pageIndex == 0 && currentChapter!.previous == null) {
      showToast(S.of(context).isBookHeader);
      return;
    }
    _pageController.previousPage(
        duration: Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  void nextPage() {
    if (pageIndex == currentChapter!.pageCount - 1 &&
        currentChapter!.next == null) {
      showToast(S.of(context).isBookFooter);
      return;
    }
    _pageController.nextPage(
        duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
  }

  /// 点击事件
  void onTapUp(Offset position) async {
    debugPrint(
        'onTap dx ${position.dx} px,dy ${position.dy} px,direction ${position.direction},distance ${position.distance}');
    double xRate = position.dx / ScreenUtil.width;
    if (xRate > 0.33 && xRate < 0.66) {
      // 中间区域，触发菜单
      menuVisible = true;
      setState(() {});
    } else if (xRate >= 0.66) {
      // 右侧区域
      nextPage();
    } else {
      // 左侧区域
      previousPage();
    }
  }

  void onPageChanged(int index) async {
    debugPrint('onPageChanged index $index.');
    var page = index - (preChapter != null ? preChapter!.pageCount : 0);
    debugPrint('onPageChanged page $page');
    if (page < currentChapter!.pageCount && page >= 0) {
      pageIndex = page;
    }

    if (page == currentChapter!.pageCount) {
      arriveNextChapter();
    } else if (page == -1) {
      arrivePreviousChapter();
    }

//    var chapter;
//    var backIndex;
//    if (pageIndex == currentChapter.pageCount) {
//      // 到达下一章了
//      chapter = nextChapter;
//      backIndex = preChapter.pageCount - 1;
//    } else if (pageIndex == -1) {
//      // 到达上一章了
//      chapter = preChapter;
//      backIndex = preChapter.pageCount - 1;
//    }
//    checkChapterProperty(chapter);
//
//    bool right = await checkChapterProperty(chapter);
//    debugPrint('Check chapter property $right.');
//    if (!right) {
//      // 购买失败，回到原页面
//      _pageController.jumpToPage(backIndex);
//      return;
//    }
  }

  /// 构建单页
  Widget itemBuilder(BuildContext context, int index) {
    debugPrint('itemBuilder index $index');

    // 每个章节的页码，在页面右下角显示。
    var pageIndex = index - (preChapter != null ? preChapter!.pageCount : 0);

    var chapter;
    if (pageIndex >= currentChapter!.pageCount) {
      // 到达下一章了
      chapter = nextChapter;
      pageIndex = 0;
    } else if (pageIndex < 0) {
      // 到达上一章了
      chapter = preChapter;
      pageIndex = preChapter!.pageCount - 1;
    } else {
      chapter = currentChapter;
    }

    debugPrint('itemBuilder page index  $pageIndex of per chapter');

    return GestureDetector(
      onTapUp: (TapUpDetails details) {
        onTapUp(details.globalPosition);
      },
      child: ReaderView(
        chapter: chapter,
        pageIndex: pageIndex,
        topSafeHeight: topSafeHeight,
        bottomSafeHeight: bottomSafeHeight,
        readerModel: readerModel,
      ),
    );
  }

  /// 构建书籍内容视图
  Widget buildContent() {
    int itemCount = (preChapter != null ? preChapter!.pageCount : 0) +
        currentChapter!.pageCount +
        (nextChapter != null ? nextChapter!.pageCount : 0);

    debugPrint('itemCount $itemCount');

    return PageView.builder(
      physics: const BouncingScrollPhysics(),
      pageSnapping: true,
      controller: _pageController,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      onPageChanged: onPageChanged,
    );
  }

  refreshMenu(int index) {
    setState(() {
      menuVisible = !(index == ReaderModel.nothing);
      catalogVisible = index == ReaderModel.catalog;
      prefsVisible = index == ReaderModel.prefs;
    });
  }

  /// 构建菜单页面
  Widget buildMenu() {
    if (menuVisible) {
      return ReaderMenu(
        chapters: chapters,
        book: widget.book,
        chapterIndex: currentChapter!.index,
        readerModel: readerModel,
        onTap: (index) {
          refreshMenu(index);
        },
        onPreviousChapter: () async {
          bool right =
              await checkChapterProperty(currentChapter!.previous!, false);
          if (!right) return;
          resetContent(currentChapter!.previous!, PageJumpType.firstPage);
        },
        onNextChapter: () async {
          bool right = await checkChapterProperty(currentChapter!.next!, false);
          if (!right) return;
          resetContent(currentChapter!.next!, PageJumpType.firstPage);
        },
        onSlideChapter: (Chapter chapter) async {
          bool right = await checkChapterProperty(chapter, false);
          if (!right) return;
          resetContent(chapter, PageJumpType.firstPage);
        },
        onBackTap: () async {
          Navigator.pop(context);
        },
      );
    } else {
      return Container();
    }
  }

  /// 构建设置页面
  Widget buildPrefs() {
    if (prefsVisible) {
      return ReaderPrefsBar(
          onTap: (index) {
            refreshMenu(index);
          },
          onLayout: () {
            resetContent(currentChapter!, PageJumpType.stay);
          },
          readerModel: readerModel);
    } else {
      return Container();
    }
  }

  /// 构建书籍目录页面
  Widget buildCatalog() {
    if (catalogVisible) {
      return ReaderCatalog(
        book: widget.book,
        chapters: chapters,
        currentChapterId: currentChapter!.idx!,
        onTap: (index) {
          refreshMenu(index);
        },
        onJumpChapter: (chapter) {
          resetContent(chapter, PageJumpType.firstPage);
        },
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$lifeCycleTag $this build, context $context');
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    if (currentChapter == null || chapters == null) {
      return Material(
        child: Stack(
          children: <Widget>[
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                bottom: 0,
                child: isDark
                    ? Container(
                        color: Theme.of(context).cardColor,
                      )
                    : Image.asset(Util.assetImage('read_bg.png'),
                        fit: BoxFit.cover)),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const CircularProgressIndicator(),
                  const SpaceDivider(height: 24),
                  Text(
                    S.of(context).loadChapterContent,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ProviderWidget<ReaderModel>(
      autoDispose: false,
      model: readerModel,
      builder: (_, model, child) {
        return Material(
          child: Stack(
            children: <Widget>[
              Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: isDark
                      ? Container(
                          color: Theme.of(context).cardColor,
                        )
                      : Image.asset(Util.assetImage('read_bg.png'),
                          fit: BoxFit.cover)),
              buildContent(),
              buildMenu(),
              buildPrefs(),
              buildCatalog(),
            ],
          ),
        );
      },
    );
  }
}
