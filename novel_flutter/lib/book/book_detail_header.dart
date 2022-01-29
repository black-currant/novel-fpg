import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/item_container.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// 书籍信息+书籍标签视图
/// 页面：书籍详情页的头部
class BookDetailHeaderView extends StatelessWidget {
  final Book book;

  const BookDetailHeaderView({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBook(context),
          _buildTags(context),
        ],
      ),
    );
  }

  /// 书籍视图
  Widget _buildBook(BuildContext context) {
    return Row(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, RouteName.image,
                arguments: book.getCover());
          },
          child: Image(
            image: ExtendedNetworkImageProvider(book.getCover(),
                cache: true,
                retries: 3,
                timeLimit: const Duration(milliseconds: 100),
                timeRetry: const Duration(milliseconds: 100)),
            width: 104,
            height: 132,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Image.asset(Util.assetImage('image_placeholder.png'));
            },
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Image.asset(Util.assetImage('image_error.png'));
            },
          ),
        ),
        const SpaceDivider.medium(),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${book.title}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SpaceDivider.tiny(),
              Text(
                '${book.intro}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const SpaceDivider.tiny(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    '${book.author}',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SpaceDivider.small(),
                  Visibility(
                    visible: book.category!.isNotEmpty,
                    child: Container(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.5,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(2.0))),
                      child: Text(
                        '${book.category}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                ],
              ),
              const SpaceDivider.tiny(),
              Row(
                children: <Widget>[
                  Text(
                    book.finished ? '已完结' : '连载中',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  const SpaceDivider.small(),
                  Text(
                    book.getWordCountText(context),
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 标签
  Widget _buildTags(BuildContext context) {
    if (book.tags!.isEmpty) {
      return Container();
    }
    const colors = [
      Color(0xFF448aff),
      Color(0xFFff3d00),
      Color(0xFFb27cff),
      Color(0xFF00c29a),
      Color(0xFFff9100),
      Color(0xFFff7373)
    ];
    var i = 0;
    List<String> _tags = book.tags!.split(',');
    var tagWidgets = _tags.map((tag) {
      var color = colors[i % colors.length];
      var tagWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Color.fromARGB(99, color.red, color.green, color.blue),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.fromLTRB(6, 3, 6, 3),
        child: Text(
          tag,
          style: Theme.of(context)
              .textTheme
              .caption!
              .copyWith(color: colors[i % 3]),
        ),
      );
      i++;
      return tagWidget;
    }).toList();
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 10,
        spacing: 10,
        children: tagWidgets,
      ),
    );
  }
}
