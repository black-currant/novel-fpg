import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:flutter/material.dart';

/// 阅读器书籍扉页
class ReaderTitleView extends StatelessWidget {
  final ReaderModel readerModel;

  const ReaderTitleView({Key? key, required this.readerModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(left: 0, top: 0, right: 0, bottom: 0, child: Container()),
        _buildContent(context, readerModel.book),
      ],
    );
  }

  _buildContent(BuildContext context, Book book) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image(
            image: NetworkImage(book.getCover()),
            width: 120,
            height: 180,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            '${book.title}',
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(
            '${book.author} / ${S.of(context).works}',
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }
}
