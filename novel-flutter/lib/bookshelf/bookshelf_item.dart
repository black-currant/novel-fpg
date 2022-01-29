import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookshelf/bookshelf.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/navigation_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 书架项
class BookShelfItem extends StatelessWidget {
  final Book book;

  const BookShelfItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isGotoBookstore = book.title == kGotoBookstore;
    return isGotoBookstore ? _buildBookstore(context) : _buildBook(context);
  }

  Widget _buildBook(BuildContext context) {
    return InkWell(
      onTap: () {
        if (book.title == kGotoBookstore) {
          Provider.of<NavigationModel>(context, listen: false).select(1);
        } else {
          Chapter chapter = lastReadingRecords(book.id!);
          Navigator.of(context)
              .pushNamed(RouteName.reader, arguments: [book, chapter]);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: itemDecoration(context: context),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.all(Radius.circular(bookCoverRadius)),
                child: Image(
                  image: ExtendedNetworkImageProvider(book.getCover(),
                      cache: true,
                      retries: 3,
                      timeLimit: const Duration(milliseconds: 100),
                      timeRetry: const Duration(milliseconds: 100)),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
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
                //   imageUrl: book.getCover(),
                //   width: double.infinity,
                //   height: double.infinity,
                //   fit: BoxFit.fill,
                //   placeholder: (context, url) =>
                //       Image.asset(Util.assetImage('image_placeholder.png')),
                //   errorWidget: (context, url, error) =>
                //       Image.asset(Util.assetImage('image_error.png')),
                // ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${book.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SizedBox(height: 2),
          Text(
            '${book.author}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildBookstore(BuildContext context) {
    return IconButton(
      onPressed: () {
        NavigationModel model =
            Provider.of<NavigationModel>(context, listen: false);
        model.select(1);
      },
      icon: Icon(
        Icons.add,
        color: Theme.of(context).colorScheme.secondary,
        size: 36,
      ),
    );
  }
}

class BookShelfSkeleton extends StatelessWidget {
  const BookShelfSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const <Widget>[
        SizeSkeleton(
          width: 20,
          height: 10,
        ),
        SpaceDivider.small(),
        SizeSkeleton(
          width: 20,
          height: 10,
        ),
        SpaceDivider.tiny(),
        SizeSkeleton(
          width: 50,
          height: 10,
        ),
      ],
    );
  }
}
