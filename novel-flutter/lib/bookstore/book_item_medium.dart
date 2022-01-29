import 'dart:math';

import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/item_button.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

/// 书籍项视图
/// 中号视图，水平显示
class BookItemMedium extends StatelessWidget {
  final Book item;
  final bool pushReplacement;

  const BookItemMedium({
    Key? key,
    required this.item,
    this.pushReplacement = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemButton(
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
      verPadding: 0.0,
      horPadding: 0.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RouteName.image,
                  arguments: item.getCover());
            },
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
          const SpaceDivider(width: dividerSmallSize),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SizedBox(height: 6),
                Text(
                  item.intro ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                      item.author ?? '',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    const SpaceDivider(width: dividerSmallSize),
                    Visibility(
                      visible: item.category!.isNotEmpty,
                      child: Container(
                        padding: const EdgeInsets.only(left: 2, right: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color:
                                  Theme.of(context).textTheme.caption!.color!,
                              width: 0.5,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(2.0))),
                        child: Text(
                          item.category ?? '',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                    ),
                    const SpaceDivider(width: dividerSmallSize),
                    Text(
                      item.getWordCountText(context),
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SpaceDivider(width: dividerSmallSize),
        ],
      ),
    );
  }
}

/// BookItemMedium对应的骨架，用于加载动画
class BookSkeletonMedium extends StatelessWidget {
  const BookSkeletonMedium({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2;
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
                width: Random.secure().nextDouble() * width,
                height: 20,
              ),
              const SpaceDivider.medium(),
              SizeSkeleton(
                width: Random.secure().nextDouble() * width,
                height: 10,
              ),
              const SpaceDivider.tiny(),
              SizeSkeleton(
                width: Random.secure().nextDouble() * width,
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
        const SpaceDivider.small(),
      ],
    );
  }
}
