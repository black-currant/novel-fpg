import 'dart:async';

import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/book/catalog_item_small.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/consume_score_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'reader_config.dart';

/// 阅读器目录
class ReaderCatalog extends StatefulWidget {
  final Book book;
  final int currentChapterId;
  final List<Chapter> chapters;
  final void Function(int index) onTap;
  final void Function(Chapter chapter) onJumpChapter;

  const ReaderCatalog(
      {Key? key,
      required this.book,
      required this.currentChapterId,
      required this.chapters,
      required this.onTap,
      required this.onJumpChapter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ReaderCatalogState();
}

class _ReaderCatalogState extends State<ReaderCatalog>
    with SingleTickerProviderStateMixin {
  late Book _book;
  bool _reverse = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  late ConsumeScoreModel _consumeScoreModel;

  void setup() async {}

  @override
  void initState() {
    super.initState();
    setup();
    _book = widget.book;

    _controller = AnimationController(
      duration: Duration(milliseconds: ReaderConfig.duration),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.forward();

    _consumeScoreModel = ConsumeScoreModel(Provider.of(context, listen: false));
  }

  @override
  void dispose() {
    _controller.dispose();
    _consumeScoreModel.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    double width = ScreenUtil.width * 2 / 3;
    return Positioned(
      height: ScreenUtil.height,
      left: -width * (1 - _controller.value),
      child: Container(
        width: width,
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ScreenUtil.topSafeHeight,
            ),
            _buildTopBar(),
            _buildTotalSort(),
            Expanded(
              child: Container(
                child: _buildListView(),
              ),
            ),
            SizedBox(
              height: ScreenUtil.bottomSafeHeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: kToolbarHeight,
      alignment: Alignment.center,
      child: Text(
        _book.title ?? '',
        style: const TextStyle(fontSize: 16),
        maxLines: 1,
      ),
    );
  }

  Widget _buildTotalSort() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              S.of(context).total +
                  widget.chapters.length.toString() +
                  S.of(context).chapter,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        IconButton(
          icon: Image.asset(_reverse
              ? Util.assetImage("sort_asc.png")
              : Util.assetImage("sort_desc.png")),
          onPressed: () {
            setState(() {
              _reverse = !_reverse;
            });
          },
        ),
      ],
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => spaceDividerSmall,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 0),
      shrinkWrap: true,
      itemCount: widget.chapters.length,
      reverse: _reverse,
      itemBuilder: (context, index) {
        Chapter item = widget.chapters[index];
        if (item.idx == widget.currentChapterId) item.selected = true;
        return CatalogItemSmall(
          item: widget.chapters[index],
          bookId: _book.id ?? 0,
          model: _consumeScoreModel,
          onTap: (item) {
            hide(ReaderModel.nothing);
            widget.onJumpChapter(item);
          },
        );
      },
    );
  }

  hide(int viewIndex) async {
    _controller.reverse();
    Timer(Duration(milliseconds: ReaderConfig.duration), () {
      widget.onTap(viewIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTapDown: (_) {
            hide(ReaderModel.nothing);
          },
          child: Container(color: Colors.transparent),
        ),
        _buildBody(),
      ],
    );
  }
}
