import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

double bookItemSmallAspectRatio() {
//  double ratio =
//      double.parse((ScreenUtil.width / ScreenUtil.height).toStringAsFixed(2));
  // iPone11 0.46
  // iPone7 0.56
  // Pixel1 0.60
  double ratio = 0.54; // 取最适合iPhone11的值
  debugPrint('Book item small aspect ratio $ratio.');
  return ratio;
}

/// 书籍项视图
/// 小号视图，垂直显示
class BookItemSmall extends StatelessWidget {
  final Book item;
  final bool pushReplacement;

  const BookItemSmall({
    Key? key,
    required this.item,
    this.pushReplacement = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (pushReplacement) {
          Navigator.of(context).pushReplacementNamed(
            RouteName.bookDetail,
            arguments: item,
          );
        } else {
          Navigator.of(context).pushNamed(
            RouteName.bookDetail,
            arguments: item,
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(bookCoverRadius)),
              child: Image(
                image: ExtendedNetworkImageProvider(
                  item.getCover(),
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
          const SpaceDivider.small(),
          Text(
            '${item.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle2,
          ),
          const SpaceDivider.tiny(),
          Text(
            '${item.author}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}

class BookSkeletonSmall extends StatelessWidget {
  const BookSkeletonSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        Expanded(
          child: SizeSkeleton(
            width: bookCoverWidth,
            height: bookCoverHeight,
          ),
        ),
        SpaceDivider.small(),
        SizeSkeleton(
          width: 20,
          height: 10,
        ),
        SpaceDivider.tiny(),
        SizeSkeleton(
          width: 20,
          height: 10,
        ),
      ],
    );
  }
}
