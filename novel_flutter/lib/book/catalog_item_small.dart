import 'dart:math';

import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/reader/insufficient_balance_dialog.dart';
import 'package:novel_flutter/reader/purchase_chapter_dialog.dart';
import 'package:novel_flutter/reader/reader_prefs_model.dart';
import 'package:novel_flutter/view_model/consume_score_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/widgets/loading_dialog.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 书籍目录项
class CatalogItemSmall extends StatefulWidget {
  final Chapter item;
  final int bookId;
  final ConsumeScoreModel model;
  final Function(Chapter item)? onTap;

  const CatalogItemSmall({
    Key? key,
    required this.item,
    required this.bookId,
    required this.model,
    this.onTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<CatalogItemSmall> {
  late Chapter _chapter;
  late ConsumeScoreModel _model;

  @override
  void initState() {
    super.initState();
    _chapter = widget.item;
    _model = widget.model;
    _chapter.bookId = widget.bookId;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (widget.onTap == null) return;

        if (_chapter.have) {
          widget.onTap!(_chapter);
        } else {
          if (checkLogin(context: context)) return;
          int score = context.read<UserModel>().user.score!;
          bool insufficient = score < _chapter.price; // 余额不足
          if (insufficient) {
            await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, state) {
                  return InsufficientBalanceDialog(chapter: _chapter);
                });
              },
            );
            return;
          }
          bool automaticRenewal =
              Persistence.sharedPreferences.getBool(kAutomaticRenewal) ?? false;
          if (automaticRenewal) {
            showLoadingDialog(context, S.of(context).purchasingChapter);
            bool purchased = await _model.request(
                _chapter.idx!, _chapter.bookId, _chapter.price);
            closeLoadingDialog(context);
            if (purchased) {
              // 购买成功
              _chapter.have = true;
              setState(() {});
              widget.onTap!(_chapter);
            }
          } else {
            bool purchased = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, state) {
                        return PurchaseChapterDialog(
                          chapter: _chapter,
                          setState: state,
                        );
                      });
                    }) ??
                false;
            _chapter.have = purchased;
            if (purchased) widget.onTap!(_chapter);
          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Text(
              '${widget.item.title}',
              style: widget.item.selected
                  ? Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Theme.of(context).colorScheme.secondary)
                  : Theme.of(context).textTheme.subtitle2,
            ),
          ),
          _buildLabel(context),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      widget.item.have ? '' : 'VIP',
      style: widget.item.have
          ? widget.item.selected
              ? Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(color: Theme.of(context).colorScheme.secondary)
              : Theme.of(context).textTheme.subtitle2
          : Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: const Color(0xFFff8f00)),
    );
  }
}

class CatalogSkeletonSmall extends StatelessWidget {
  const CatalogSkeletonSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width / 2;
    width = Random.secure().nextDouble() * width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizeSkeleton(width: width, height: 20.0),
        const SizeSkeleton(width: 20.0, height: 20.0),
      ],
    );
  }
}
