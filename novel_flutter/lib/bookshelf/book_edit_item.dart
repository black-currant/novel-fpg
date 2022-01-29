import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// 书籍项视图
/// 中号视图，水平显示
/// 有选择按钮的
class BookEditItem extends StatefulWidget {
  final Book item;
  final void Function(bool selected, int id) onTap;

  const BookEditItem({Key? key, required this.item, required this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<BookEditItem> {
  late Book _book;

  @override
  void initState() {
    super.initState();
    _book = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: itemDecoration(context: context),
      child: Material(
        child: InkWell(
          onTap: () {
            _book.toggleSelect();
            widget.onTap(_book.selected, _book.id!);
            setState(() {});
          },
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(bookCoverRadius)),
                child: Image(
                  image: ExtendedNetworkImageProvider(_book.getCover(),
                      cache: true,
                      retries: 3,
                      timeLimit: const Duration(milliseconds: 100),
                      timeRetry: const Duration(milliseconds: 100)),
                  width: bookCoverWidth,
                  height: bookCoverHeight,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Image.asset(
                        Util.assetImage('image_placeholder.png'));
                  },
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Image.asset(Util.assetImage('image_error.png'));
                  },
                ),
                // CachedNetworkImage(
                //   imageUrl: _book.getCover(),
                //   width: bookItemMediumWidth,
                //   height: bookItemMediumHeight,
                //   fit: BoxFit.cover,
                //   placeholder: (context, url) =>
                //       Image.asset(Util.assetImage('image_placeholder.png')),
                //   errorWidget: (context, url, error) =>
                //       Image.asset(Util.assetImage('image_error.png')),
                // ),
              ),
              const SpaceDivider(width: dividerSmallSize),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${_book.title}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_book.intro}',
                      maxLines: 2,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const SizedBox(height: 6),
                    Text('${_book.author}',
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
              const SpaceDivider(width: dividerSmallSize),
              Image.asset(Util.assetImage(
                  _book.selected ? 'select.png' : 'select_false.png')),
              const SpaceDivider(width: dividerSmallSize),
            ],
          ),
        ),
      ),
    );
  }
}

class BookEditSkeleton extends StatelessWidget {
  const BookEditSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(bookCoverRadius)),
          child: SizeSkeleton(
            width: bookCoverWidth,
            height: bookCoverHeight,
          ),
        ),
        const SpaceDivider.small(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizeSkeleton(
                width: MediaQuery.of(context).size.width / 2,
                height: 20,
              ),
              const SpaceDivider.medium(),
              const SizeSkeleton(
                width: double.infinity,
                height: 10,
              ),
              const SpaceDivider.tiny(),
              const SizeSkeleton(
                width: double.infinity,
                height: 10,
              ),
              const SpaceDivider.medium(),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: const <Widget>[
                  SizeSkeleton(
                    width: 50,
                    height: 10,
                  ),
                  SpaceDivider.small(),
                  SizeSkeleton(
                    width: 10,
                    height: 10,
                  ),
                  SpaceDivider.small(),
                  SizeSkeleton(
                    width: 50,
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SpaceDivider.medium(),
        const SizeSkeleton(
          width: 24,
          height: 24,
        ),
      ],
    );
  }
}
