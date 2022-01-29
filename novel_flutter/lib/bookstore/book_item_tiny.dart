import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/item_button.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

const double bookItemTinyWidth = 84.0;
const double bookItemTinyHeight = 120.0;
const double bookItemTinyHorDividerSize = 7.5;

/// 书籍项视图
/// 小小号视图
class BookItemTiny extends StatelessWidget {
  final Book item;
  final double? width;
  final double? height;
  final double dividerSize;
  final Function(Book book)? onTap; // 默认进详情页

  const BookItemTiny({
    Key? key,
    required this.item,
    this.width,
    this.height,
    this.dividerSize = 0.0,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemButton(
      horMargin: dividerSize,
      onTap: () {
        if (onTap == null) {
          Navigator.of(context)
              .pushNamed(RouteName.bookDetail, arguments: item);
        } else {
          onTap!(item);
        }
      },
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(bookCoverRadius)),
        child: Image(
          image: ExtendedNetworkImageProvider(
            item.getCover(),
            cache: true,
            retries: 3,
            timeLimit: const Duration(milliseconds: 100),
            timeRetry: const Duration(milliseconds: 100),
          ),
          width: width,
          height: height,
          fit: BoxFit.fill,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) return child;
            return Image.asset(Util.assetImage('image_placeholder.png'));
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Image.asset(Util.assetImage('image_error.png'));
          },
        ),
      ),
    );
  }
}

class BookSkeletonTiny extends StatelessWidget {
  const BookSkeletonTiny({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(bookCoverRadius)),
      child: SizeSkeleton(
        width: bookItemTinyWidth,
        height: bookItemTinyHeight,
      ),
    );
  }
}
