import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/book/book_detail_header.dart';
import 'package:novel_flutter/bookshelf/bookshelf.dart';
import 'package:novel_flutter/bookstore/book_recommend.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/model/edit_state.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/view_model/bookshelf_model.dart';
import 'package:novel_flutter/widgets/button_progress_indicator.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 加入书架
Future<bool> addBookshelf(BuildContext context, int bookId) async {
  BookshelfModel model = Provider.of<BookshelfModel>(context, listen: false);
  model.addSelect(bookId);
  bool result = await model.update(EditState.add);
  showToast(result
      ? S.of(context).operationSucceeded
      : S.of(context).operationFailed);
  // 同时发送刷新书架的通知
  return result;
}

/// 书籍首页，或者书籍详情页
class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({Key? key, required this.book}) : super(key: key);

  Widget _buildBottomSheet(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: ProviderWidget<BookshelfModel>(
            model: Provider.of<BookshelfModel>(context, listen: false),
            builder: (context, model, child) {
              return InkWell(
                onTap: () {
                  if (checkLogin(context: context)) return;
                  if (model.isBusy) return; // 在请求期间过滤重复操作
                  if (model.inBookshelf(book.id!)) return;
                  addBookshelf(context, book.id!);
                },
                child: Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: model.isBusy
                      ? ButtonProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                        )
                      : Text(
                          model.inBookshelf(book.id!)
                              ? S.of(context).onTheBookshelf
                              : S.of(context).addTheBookshelf,
                          style: Theme.of(context).textTheme.button!.copyWith(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: InkWell(
            child: Container(
              height: 50.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                gradient: accentGradient,
              ),
              child: Text(
                S.of(context).startReading,
                style: Theme.of(context)
                    .textTheme
                    .button!
                    .copyWith(color: Colors.white),
              ),
            ),
            onTap: () {
              if (checkLogin(context: context)) return;
              // 开始阅读
              // showLoadingDialog(context, '请在读取内容，请稍等...');
              Chapter chapter = lastReadingRecords(book.id!);
              Navigator.of(context).pushNamed(
                RouteName.reader,
                arguments: [book, chapter],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCatalog(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.all(itemPadding),
      decoration: itemDecoration(context: context),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Text(
              S.of(context).catalog + ': ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Text(
                S.of(context).latest + book.recentChapter!,
                style: Theme.of(context).textTheme.subtitle1,
                maxLines: 1,
              ),
            ),
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
        onTap: () {
          Navigator.of(context).pushNamed(RouteName.catalog, arguments: book);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: pageEdgeInsets,
      child: Column(
        children: <Widget>[
          BookDetailHeaderView(book: book),
          const SpaceDivider.medium(),
          _buildCatalog(context),
          const SpaceDivider.medium(),
          MaybeLikeView(book: book, pushReplacement: true),
          const SpaceDivider.medium(),
          SameTypeView(book: book, pushReplacement: true),
          const SpaceDivider(height: 64),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title!)),
      body: _buildBody(context),
      bottomSheet: _buildBottomSheet(context),
    );
  }
}
