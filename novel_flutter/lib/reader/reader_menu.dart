import 'dart:async';

import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/book/book_detail.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:novel_flutter/settings/general.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:novel_flutter/view_model/bookshelf_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 阅读器菜单
class ReaderMenu extends StatefulWidget {
  final List<Chapter> chapters;
  final Book book;
  final int chapterIndex;
  final ReaderModel readerModel;

  final void Function(int index) onTap;
  final GestureTapCallback onPreviousChapter;
  final GestureTapCallback onNextChapter;
  final void Function(Chapter chapter) onSlideChapter;
  final GestureTapCallback onBackTap;

  const ReaderMenu({
    Key? key,
    required this.chapters,
    required this.book,
    required this.chapterIndex,
    required this.onTap,
    required this.onPreviousChapter,
    required this.onNextChapter,
    required this.onSlideChapter,
    required this.readerModel,
    required this.onBackTap,
  }) : super(key: key);

  @override
  _ReaderMenuState createState() => _ReaderMenuState();
}

// 弹出菜单
enum MorePopupMenu {
  share,
}

class _ReaderMenuState extends State<ReaderMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late Book _book;
  late double progressValue;
  bool isTipVisible = false;

  @override
  initState() {
    super.initState();
    setup();
    _book = widget.book;
    progressValue = widget.chapterIndex / (widget.chapters.length - 1);

    _controller = AnimationController(
      duration: const Duration(milliseconds: ReaderConfig.duration),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide(ReaderModel.nothing);
            },
            child: Container(color: Colors.transparent),
          ),
          _buildTopView(context),
          _buildAddBookshelfView(),
          _buildBottomView(),
        ],
      ),
    );
  }

  @override
  void didUpdateWidget(ReaderMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    progressValue = widget.chapterIndex / (widget.chapters.length - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setup() async {
    // 设置系统栏可见性
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top,
      SystemUiOverlay.bottom,
    ]);
  }

  /// 隐藏菜单
  void hide(int index) {
    // 隐藏动画
    _controller.reverse();
    // 设置系统栏可见性
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Timer(const Duration(milliseconds: ReaderConfig.duration), () {
      widget.onTap(index);
    });
    setState(() {
      isTipVisible = false;
    });
  }

  /// 退出阅读
  void exitReader() {
    Navigator.pop(context);
  }

  Widget _buildTopView(BuildContext context) {
    return Positioned(
      top: -ScreenUtil.appBarAndSysBarHeight * (1 - _animation.value),
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        padding: EdgeInsets.only(top: ScreenUtil.topSafeHeight),
        child: SizedBox(
          height: kToolbarHeight,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                child: BackButton(onPressed: widget.onBackTap),
              ),
              Positioned.fill(
                child: Center(
                  child: Text(
                    _book.title ?? '',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ),
//          IconButton(
//              onPressed: () {
//                showToast("");
//              },
//              icon: Image.asset('img/read_icon_voice.png')),

//          PopupMenuButton(
//              icon: MyIcons.more,
//              onSelected: (value) {
//                showToast(value.toString());
//              },
//              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                    const PopupMenuItem(
//                      child: ListTile(
//                        leading: Icon(Icons.add_circle_outline),
//                        title: Text("popupMenuButton1"),
//                      ),
//                    ),
//                    const PopupMenuItem(
//                      child: ListTile(
//                        leading: Icon(Icons.add_circle_outline),
//                        title: Text("popupMenuButton2"),
//                      ),
//                    ),
//                  ]),
            ],
          ),
        ),
      ),
    );
  }

  /// 加入书架
  Widget _buildAddBookshelfView() {
    return ProviderWidget<BookshelfModel>(
        model: Provider.of<BookshelfModel>(context, listen: false),
        builder: (context, model, child) {
          return Visibility(
            visible: !model.inBookshelf(_book.id ?? 0),
            child: Positioned(
              top: ScreenUtil.appBarAndSysBarHeight + 30,
              right: -120 * (1 - _animation.value),
              child: InkWell(
                onTap: () async {
                  if (checkLogin(context: context)) return;
                  bool successful = await addBookshelf(context, _book.id ?? 0);
                  if (successful) setState(() {});
                },
                child: Container(
                  width: 120,
                  padding: const EdgeInsets.fromLTRB(10, 7, 0, 7),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(50),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.add_circle,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 5),
                      Text(S.of(context).addTheBookshelf,
                          style: Theme.of(context).textTheme.subtitle1),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  int currentChapterIndex() {
    return ((widget.chapters.length - 1) * progressValue).toInt();
  }

  _buildProgressTipView() {
    if (!isTipVisible) {
      return Container();
    }
    Chapter chapter = widget.chapters[currentChapterIndex()];
    double percentage = chapter.idx! / (widget.chapters.length - 1) * 100;
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(chapter.title ?? '',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white)),
          Text('${percentage.toStringAsFixed(1)}%',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white)),
        ],
      ),
    );
  }

  previousChapter() {
    if (widget.chapterIndex == 0) {
      showToast(S.of(context).isBookHeader);
      return;
    }
    widget.onPreviousChapter();
    setState(() {
      isTipVisible = true;
    });
  }

  nextChapter() {
    if (widget.chapterIndex == widget.chapters.length - 1) {
      showToast(S.of(context).isBookFooter);
      return;
    }
    widget.onNextChapter();
    setState(() {
      isTipVisible = true;
    });
  }

  Widget _buildBottomView() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      bottom: -(ScreenUtil.bottomSafeHeight + 240) * (1 - _animation.value),
      left: 0,
      right: 0,
      child: Column(
        children: <Widget>[
          _buildProgressTipView(),
          Container(
            color: Theme.of(context).colorScheme.primary,
            padding: EdgeInsets.only(bottom: ScreenUtil.bottomSafeHeight),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        onPressed: previousChapter,
                        child: Text(
                          S.of(context).previousChapter,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: progressValue,
                          onChanged: (double value) {
                            setState(() {
                              isTipVisible = true;
                              progressValue = value;
                            });
                          },
                          onChangeEnd: (double value) {
                            Chapter chapter =
                                widget.chapters[currentChapterIndex()];
                            widget.onSlideChapter(chapter);
                          },
                          activeColor: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      TextButton(
                        onPressed: nextChapter,
                        child: Text(
                          S.of(context).nextChapter,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildItem(
                        S.of(context).catalog, Icons.format_list_bulleted, () {
                      hide(ReaderModel.catalog);
                    }),
                    _buildItem(
                        isDark ? S.of(context).daytime : S.of(context).night,
                        isDark ? Icons.brightness_7 : Icons.brightness_3, () {
                      switchDarkMode(context);
//                      widget.readerModel.refreshDarkModel();
                      hide(ReaderModel.nothing);
                    }),
                    _buildItem(S.of(context).prefs, Icons.settings, () {
                      hide(ReaderModel.prefs);
                    }),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildItem(String label, IconData icon, GestureTapCallback onTap) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
            ),
            const SizedBox(height: 5),
            Text(label, style: Theme.of(context).textTheme.caption),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
