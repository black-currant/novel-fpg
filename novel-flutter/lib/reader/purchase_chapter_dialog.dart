import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/reader_prefs_model.dart';
import 'package:novel_flutter/view_model/consume_score_model.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 阅读器
/// 购买章节对话框
class PurchaseChapterDialog extends Dialog {
  final Chapter chapter;
  final StateSetter setState;
  late bool _automaticRenewal;

  PurchaseChapterDialog({
    required this.chapter,
    required this.setState,
  }) {
    _automaticRenewal =
        Persistence.sharedPreferences.getBool(kAutomaticRenewal) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 3 * 2,
          height: MediaQuery.of(context).size.height / 5 * 2,
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ProviderWidget<ConsumeScoreModel>(
      model: ConsumeScoreModel(Provider.of(context, listen: false)),
      builder: (_, model, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 48,
              color: Theme.of(context).colorScheme.secondary,
              alignment: Alignment.center,
              child: Text(
                S.of(context).purchaseChapter,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalMargin,
              ),
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
            const SizedBox(height: 5),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: '${S.of(context).balance}: ',
                    style: Theme.of(context).textTheme.subtitle1),
                TextSpan(
                    text:
                        '${model.userModel.user.score}${S.of(context).virtualCurrency}',
                    style: Theme.of(context).accentTextTheme.subtitle1),
              ]),
            ),
            Expanded(child: Container()),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Checkbox(
                  value: _automaticRenewal,
                  activeColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) {
                    setState(() {
                      // 整个dialog会重绘
                      _automaticRenewal = value!;
                    });
                    Persistence.sharedPreferences
                        .setBool(kAutomaticRenewal, value!);
                  },
                ),
                Text(
                  S.of(context).automaticRenewal,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: verticalMargin,
                left: horizontalMargin,
                right: horizontalMargin,
              ),
              child: InkWell(
                onTap: () async {
                  await model.request(
                    chapter.idx ?? 0,
                    chapter.bookId,
                    chapter.price,
                  );
                  if (model.isError) {
                    model.showErrorMessage(context);
                    return;
                  }
                  // 购买成功
                  chapter.have = true;
                  showToast(S.of(context).purchaseSucceeded);
                  Navigator.pop(context, true);
                },
                highlightColor: Colors.transparent,
                child: Container(
                  height: 38,
                  alignment: Alignment.center,
                  decoration: accentDecoration,
                  child: model.isBusy
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          S.of(context).gotoPurchase,
                          style: Theme.of(context).accentTextTheme.button,
                        ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
