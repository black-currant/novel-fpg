import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/bookshelf/bookshelf_item.dart';
import 'package:novel_flutter/bookstore/book_item_medium.dart';
import 'package:novel_flutter/bookstore/book_item_small.dart';
import 'package:novel_flutter/bookstore/book_recommend.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/search/search_delegate.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/bookshelf_model.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/widgets/accent_container.dart';
import 'package:novel_flutter/widgets/book_section_header.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/item_button.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 最近阅读记录
Chapter lastReadingRecords(int bookId) {
  // 某本书的最近阅读，第几章节的第几页?
  Chapter chapter = Chapter();
  int userId = Persistence.sharedPreferences.getInt(kUserId)!;
  String key = kRecentChapterId(bookId, userId);
  int chapterId = Persistence.sharedPreferences.getInt(key) ?? 0;
  chapter.idx = chapterId;
  key = kRecentPageIndex(bookId, userId);
  int pageIndex = Persistence.sharedPreferences.getInt(key) ?? 0;
  chapter.pageIndex = pageIndex;
  return chapter;
}

/// 书架
class BookshelfPage extends StatefulWidget {
  const BookshelfPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<BookshelfPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// 书架
  Widget _buildBookshelf(List<Book> books) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        BookSectionHeader(label: S.of(context).bookshelf),
        const SpaceDivider.small(),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: bookItemSmallAspectRatio(),
            crossAxisSpacing: dividerMediumSize,
            mainAxisSpacing: dividerMediumSize,
          ),
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: books.length,
          itemBuilder: (context, index) => BookShelfItem(book: books[index]),
        ),
      ],
    );
  }

  /// 最近阅读的书籍
  Widget _buildRecentBook(Book book) {
    return ItemButton(
      horPadding: 0.0,
      verPadding: 0.0,
      onTap: () {
        Chapter chapter = lastReadingRecords(book.id!);
        Navigator.of(context)
            .pushNamed(RouteName.reader, arguments: [book, chapter]);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius:
                const BorderRadius.all(Radius.circular(bookCoverRadius)),
            child: Image(
              image: ExtendedNetworkImageProvider(book.getCover(),
                  cache: true,
                  retries: 3,
                  timeLimit: const Duration(milliseconds: 100),
                  timeRetry: const Duration(milliseconds: 100)),
              width: 96.0,
              height: 128.0,
              fit: BoxFit.cover,
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
            // CachedNetworkImage(
            //   imageUrl: book.getCover(),
            //   width: 96,
            //   height: 130,
            //   fit: BoxFit.cover,
            //   placeholder: (context, url) =>
            //       Image.asset(Util.assetImage('image_placeholder.png')),
            //   errorWidget: (context, url, error) =>
            //       Image.asset(Util.assetImage('image_error.png')),
            // ),
          ),
          const SpaceDivider.small(),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${book.title}',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                const SpaceDivider.tiny(),
                Text(
                  '${book.intro}',
                  maxLines: 2,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                const SpaceDivider.tiny(),
                // Row(
                //   mainAxisSize: MainAxisSize.max,
                //   children: <Widget>[
                //     Text(
                //       book.author ?? '',
                //       style: Theme.of(context).textTheme.caption,
                //     ),
                //     SpaceDivider.small(),
                //     Container(
                //       padding: EdgeInsets.only(left: 2, right: 2),
                //       alignment: Alignment.center,
                //       decoration: BoxDecoration(
                //           border: Border.all(
                //             width: 0.5,
                //           ),
                //           borderRadius: BorderRadius.all(Radius.circular(2.0))),
                //       child: Text(
                //         book.category ?? '',
                //         style: Theme.of(context).textTheme.caption,
                //       ),
                //     ),
                //     SpaceDivider.small(),
                //     Text(
                //       book.getWordCountText(context),
                //       style: Theme.of(context).textTheme.caption,
                //     ),
                //   ],
                // ),
                // SpaceDivider.tiny(),
                AccentContainer(
                  width: 80.0,
                  height: 28.0,
                  horPadding: 0.0,
                  verPadding: 0.0,
                  child: Text(
                    S.of(context).continueReading,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
          const SpaceDivider.small(),
        ],
      ),
    );
  }

  /// 书架无书则显示推荐书籍
  Widget _buildBookRecommend() {
    return SingleChildScrollView(
      padding: pageEdgeInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCheckIn(),
          const SpaceDivider.medium(),
          const DailyPicksView(),
          const SpaceDivider.medium(),
          const EditorChoiceView(),
        ],
      ),
    );
  }

  Widget _buildCheckIn() {
    return ProviderWidget<IncentivesModel>(
      autoDispose: false,
      model: Provider.of<IncentivesModel>(context, listen: false),
      builder: (_, model, child) {
        return Container(
          width: double.infinity,
          height: 54,
          padding: const EdgeInsets.all(itemPadding),
          decoration: itemDecoration(context: context),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(S.of(context).incentiveSlogan,
                    style: Theme.of(context).textTheme.subtitle1),
              ),
              InkWell(
                child: Container(
                  width: 60,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: accentGradient),
                  child: Text(
                    model.checkInCompleted
                        ? S.of(context).checkInAlready
                        : S.of(context).checkInAction,
                    style: Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: Colors.white),
                  ),
                ),
                onTap: () {
                  if (checkLogin(context: context)) return;
                  Navigator.of(context).pushNamed(RouteName.checkIn);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BookshelfModel bookshelfModel) {
    if (bookshelfModel.isBusy) {
      return ListShimmer(
        separatorBuilder: (context, index) => spaceDividerMedium,
        padding: pageEdgeInsets,
        itemCount: 9,
        item: const BookSkeletonMedium(),
      );
    } else if (bookshelfModel.isError) {
      return ViewStateErrorWidget(
        error: bookshelfModel.viewStateError!,
        onPressed: () async {
          switch (bookshelfModel.viewStateError!.errorType) {
            case ViewStateErrorType.unauthorizedError:
              var successful = await MyRouter.showLoginOptions(context);
              // 登录成功,获取数据,刷新页面
              if (successful ?? false) {
                bookshelfModel.initData();
              }
              break;
            default:
              bookshelfModel.initData();
              break;
          }
        },
      );
    } else if (bookshelfModel.isEmpty) {
      // return ViewStateEmptyWidget(onPressed: model.initData);
      return _buildBookRecommend();
    }

    List<Book> data = [];
    data.addAll(bookshelfModel.list);
    var book = Book(
        id: 0,
        title: kGotoBookstore,
        author: '',
        image: '',
        category: '',
        tags: '',
        intro: '',
        catalogLink: '',
        flag: 0,
        free: 0,
        value: 0,
        freeChapterCnt: 0,
        chapterCost: 0,
        recentChapter: '',
        chapterCnt: 0,
        wordsCnt: 0);
    data.add(book);
    var secondFloor = data.sublist(1);

    return SingleChildScrollView(
      padding: pageEdgeInsets,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCheckIn(),
          const SpaceDivider.medium(),
          _buildRecentBook(data[0]),
          const SpaceDivider.medium(),
          _buildBookshelf(secondFloor),
        ],
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BookshelfModel bookshelfModel) {
    return AppBar(
      titleSpacing: horizontalMargin,
      title: ProviderWidget<UserModel>(
        autoDispose: false,
        model: Provider.of(context, listen: false),
        builder: (_, model, child) {
          String readingTime =
              model.hasUser ? model.user.duration.toString() : '0';
          return Text(
            S.of(context).thisWeekRead + readingTime + S.of(context).minutes,
            maxLines: 1,
            style: Theme.of(context).textTheme.subtitle1,
          );
        },
      ),
      centerTitle: false,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            showSearch(context: context, delegate: MySearchDelegate(context));
//              Navigator.of(context).pushNamed(RouteName.search);
          },
          icon: const Icon(Icons.search),
        ),
        Offstage(
          offstage: !bookshelfModel.hasBook,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteName.editBookshelf);
            },
            icon: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BookshelfModel model = Provider.of<BookshelfModel>(context, listen: false);
    return ProviderWidget<BookshelfModel>(
      model: model,
      onModelReady: (model) => model.initData(duringBuild: true),
      builder: (_, model, child) {
        return Scaffold(
          appBar: _buildAppBar(model),
          body: _buildBody(model),
        );
      },
    );
  }
}
