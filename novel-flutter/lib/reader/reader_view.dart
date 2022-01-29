import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/utils/util.dart';

import 'reader_config.dart';
import 'reader_overlays.dart';

/// 阅读器书籍内容页
class ReaderView extends StatelessWidget {
  final Chapter chapter;
  final int pageIndex;
  final double topSafeHeight;
  final double bottomSafeHeight;
  final ReaderModel readerModel;

  const ReaderView({
    Key? key,
    required this.chapter,
    required this.pageIndex,
    required this.topSafeHeight,
    required this.bottomSafeHeight,
    required this.readerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return ProviderWidget<ReaderModel>(
      autoDispose: false,
      model: readerModel,
      builder: (_, model, child) {
        return Stack(
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
            ReaderOverlays(
              chapter: chapter,
              pageIndex: pageIndex,
              topSafeHeight: topSafeHeight,
              bottomSafeHeight: bottomSafeHeight,
            ),
            _buildContent(context, chapter, pageIndex),
          ],
        );
      },
    );
  }

  /// 书籍正文
  Widget _buildContent(BuildContext context, Chapter chapter, int pageIndex) {
    var content = chapter.textAtPageIndex(pageIndex);
    // debugPrint('Chapter No.${pageIndex + 1} page content$content');
    if (content.startsWith('\n')) {
      content = content.substring(1);
      // debugPrint('Chapter No.${pageIndex + 1} page hit$content');
    }
    return ProviderWidget<ReaderModel>(
      autoDispose: false,
      model: readerModel,
      builder: (_, model, child) {
        return Container(
          margin: EdgeInsets.fromLTRB(
            ReaderConfig.leftOffset,
            topSafeHeight + ReaderConfig.topOffset,
            ReaderConfig.rightOffset,
            bottomSafeHeight + ReaderConfig.bottomOffset,
          ),
          child: Text.rich(
            TextSpan(children: [
              TextSpan(
                text: content,
                style: TextStyle(
                  fontSize: model.fontSize,
                  height: model.lineHeight,
                ),
              ),
            ]),
            textAlign: TextAlign.start,
          ),
        );
      },
    );
  }
}
