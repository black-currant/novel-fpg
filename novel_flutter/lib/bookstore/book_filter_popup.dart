import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book_filter.dart';
import 'package:novel_flutter/model/book_price.dart';
import 'package:novel_flutter/model/book_state.dart';
import 'package:novel_flutter/model/book_word_count.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_filter_model.dart';
import 'package:novel_flutter/widgets/popup_window.dart';
import 'package:flutter/material.dart';

/// 书籍过滤弹窗
class BookFilterPopup extends StatelessWidget {
  final Function(String value) onCallback;
  final int filter;

  const BookFilterPopup(
      {Key? key, required this.filter, required this.onCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double x = 0;
    if (filter == BookFilter.bookPrice) x = -138;
    return ProviderWidget<BookFilterModel>(
      model: BookFilterModel(),
      onModelReady: (model) => model.loadData(context, filter),
      builder: (_, model, child) {
        if (model.isBusy) {
          return ViewStateBusyWidget();
        } else if (model.isError) {
          return Container();
        } else if (model.isEmpty) {
          return Container();
        }
        return PopupWindowButton(
          offset: Offset(x, 200),
          onTap: () {
            model.toggle();
          },
          child: Container(
            height: 36,
            alignment: Alignment.center,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Text(
                  model.currentLabel,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Icon(
                  model.isDropUp ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
          window: ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: horizontalMargin,
              ),
              shrinkWrap: true,
              itemCount: model.list.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    String _value = '';
                    if (model.filter == BookFilter.bookState) {
                      if (index == 0) _value = '';
                      if (index == 1) _value = BookState.serial.toString();
                      if (index == 2) _value = BookState.complete.toString();
                    } else if (model.filter == BookFilter.bookPrice) {
                      if (index == 0) _value = '';
                      if (index == 1) _value = BookPrice.member.toString();
                      if (index == 2) _value = BookPrice.free.toString();
                    } else {
                      if (index == 0) _value = '';
                      if (index == 1) _value = BookWordCount.less20w.toString();
                      if (index == 2) {
                        _value = BookWordCount.between20wTo50w.toString();
                      }
                      if (index == 3) {
                        _value = BookWordCount.between50wTo100w.toString();
                      }
                      if (index == 4) {
                        _value = BookWordCount.between100wTo200w.toString();
                      }
                      if (index == 5) {
                        _value = BookWordCount.over200w.toString();
                      }
                    }
                    onCallback(_value);
                    model.select(index);
                    model.toggle();
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    index == 0 ? S.of(context).all : model.list[index].name,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  trailing: Visibility(
                    visible: model.list[index].selected,
                    child: Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
