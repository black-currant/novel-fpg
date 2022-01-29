import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// 书籍封面项
class BookCoverItem extends StatelessWidget {
  final Book book;

  const BookCoverItem({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.bookDetail, arguments: book);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: dividerSmallSize),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.all(Radius.circular(bookCoverRadius)),
          child: Image(
            image: ExtendedNetworkImageProvider(
              book.getCover(),
              cache: true,
              retries: 3,
              timeLimit: const Duration(milliseconds: 100),
              timeRetry: const Duration(milliseconds: 100),
            ),
            width: bookCoverWidth,
            height: bookCoverHeight,
            fit: BoxFit.fill,
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
      ),
    );
  }
}

class BookCoverSkeleton extends StatelessWidget {
  const BookCoverSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: dividerSmallSize),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(bookCoverRadius)),
        child: SizeSkeleton(
          width: bookCoverWidth,
          height: bookCoverHeight,
        ),
      ),
    );
  }
}
