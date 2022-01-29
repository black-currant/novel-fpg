import 'dart:math';

import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book_type.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/item_button.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

double bookTypeItemAspectRatio() {
//  double ratio =
//      double.parse((ScreenUtil.height / ScreenUtil.width).toStringAsFixed(2));
  // iPone11 2.16
  // iPone7 1.78
  // Pixel1 1.66
  double ratio = 1.77;
  debugPrint('Book type item aspect ratio $ratio.');
  return ratio;
}

/// 书籍类型项
class BookTypeItem extends StatelessWidget {
  final BookType item;

  const BookTypeItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemButton(
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.bookList,
            arguments: [item.code, item.category]);
      },
      verPadding: 0.0,
      horPadding: 0.0,
      child: Row(
        children: <Widget>[
          ClipRRect(
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
              width: 78,
              height: double.infinity,
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
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  item.category!,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.bookCnt}${S.of(context).bookUnit}',
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookTypeSkeleton extends StatelessWidget {
  const BookTypeSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = 50.0;
    return Row(
      children: <Widget>[
        const ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(bookCoverRadius)),
          child: SizeSkeleton(
            width: 78.0,
            height: double.infinity,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizeSkeleton(
                width: Random.secure().nextDouble() * width,
                height: 16.0,
              ),
              const SpaceDivider.small(),
              SizeSkeleton(
                width: Random.secure().nextDouble() * width,
                height: 16.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
