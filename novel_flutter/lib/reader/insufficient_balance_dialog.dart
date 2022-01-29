import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 阅读器
/// 余额不足对话框
class InsufficientBalanceDialog extends Dialog {
  final Chapter chapter;

  const InsufficientBalanceDialog({Key? key, required this.chapter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 3 * 2,
          height: MediaQuery.of(context).size.height / 5 * 1.8,
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 48,
          color: Theme.of(context).colorScheme.secondary,
          alignment: Alignment.center,
          child: Text(
            S.of(context).insufficientBalance,
            style: Theme.of(context).accentTextTheme.headline6!.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
          child: Text(
            chapter.title ?? '',
            maxLines: 2,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${S.of(context).chapterPrice}: ',
                style: Theme.of(context).textTheme.subtitle1),
            TextSpan(
                text: '${chapter.price}${S.of(context).virtualCurrency}',
                style: Theme.of(context).accentTextTheme.subtitle1),
          ]),
        ),
        const SizedBox(height: 10),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${S.of(context).balance}: ',
                style: Theme.of(context).textTheme.subtitle1),
            TextSpan(
              text:
                  '${Provider.of<UserModel>(context).user.score}${S.of(context).virtualCurrency}',
              style: Theme.of(context).accentTextTheme.subtitle1!.copyWith(
                    color: Theme.of(context).errorColor,
                  ),
            ),
          ]),
        ),
      ],
    );
  }
}
