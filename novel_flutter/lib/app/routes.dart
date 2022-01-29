import 'package:novel_flutter/about/about.dart';
import 'package:novel_flutter/app/home.dart';
import 'package:novel_flutter/app/image_page.dart';
import 'package:novel_flutter/app/mine.dart';
import 'package:novel_flutter/app/text_page.dart';
import 'package:novel_flutter/app/web_page.dart';
import 'package:novel_flutter/login/view.dart';
import 'package:novel_flutter/book/catalog.dart';
import 'package:novel_flutter/book/book_detail.dart';
import 'package:novel_flutter/bookshelf/bookshelf_edit.dart';
import 'package:novel_flutter/bookstore/book_list.dart';
import 'package:novel_flutter/discovery/check_in.dart';
import 'package:novel_flutter/discovery/discovery.dart';
import 'package:novel_flutter/help/help.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/model/incentive.dart';
import 'package:novel_flutter/personal/choose_reading_prefs.dart';
import 'package:novel_flutter/personal/choose_gender.dart';
import 'package:novel_flutter/personal/edit_book_type_prefs.dart';
import 'package:novel_flutter/personal/edit_nickname.dart';
import 'package:novel_flutter/personal/user_profile.dart';
import 'package:novel_flutter/personal/wallet.dart';
import 'package:novel_flutter/reader/reader_prefs.dart';
import 'package:novel_flutter/reader/reader_scene.dart';
import 'package:novel_flutter/settings/general.dart';
import 'package:novel_flutter/settings/settings.dart';
import 'package:novel_flutter/widgets/page_route_anim.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteName {
  static const String bookshelf = 'bookshelf';
  static const String bookstore = 'bookstore';
  static const String discovery = 'discovery';
  static const String bookDetail = 'bookDetail';
  static const String chooseReadingPrefs = 'chooseReadingPrefs';
  static const String catalog = 'catalog';
  static const String reader = 'reader';
  static const String checkIn = 'checkIn';
  static const String bookList = 'bookList';
  static const String editBookshelf = 'editBookshelf';
  static const String editBookTypePrefs = 'editBookTypePrefs';
  static const String readerPrefs = 'readerPrefs';
  static const String wallet = 'wallet';
  static const String notices = 'notices';
  static const String search = 'search';
  static const String about = 'about';
  static const String general = 'general';
  static const String chooseGender = 'chooseGender';
  static const String editNickname = 'editNickname';
  static const String userProfile = 'userProfile';
  static const String settings = 'settings';
  static const String help = 'help';
  static const String mine = 'mine';
  static const String image = 'image';
  static const String web = 'web';
  static const String text = 'text';
  static const String signIn = 'signIn';
  static const String home = '/'; // 主页默认为 “/”
}

class MyRouter {
  static Route<dynamic> generateRoute({
    required RouteSettings settings,
  }) {
    switch (settings.name) {
      case RouteName.bookDetail:
        var book = settings.arguments as Book;
        return CupertinoPageRoute(builder: (_) => BookDetailPage(book: book));
      case RouteName.wallet:
        return CupertinoPageRoute(builder: (_) => const WalletPage());
      case RouteName.editBookTypePrefs:
        return CupertinoPageRoute(
            builder: (_) => const EditBookTypePrefsPage());
      case RouteName.readerPrefs:
        return CupertinoPageRoute(builder: (_) => const ReaderPrefs());
      case RouteName.bookList:
        var args = settings.arguments as List;
        var value = args[0];
        var title = args[1];
        return CupertinoPageRoute(
          builder: (_) => BookListPage(value: value, title: title),
        );
      case RouteName.editBookshelf:
        return CupertinoPageRoute(builder: (_) => const EditBookshelfPage());
      case RouteName.catalog:
        var book = settings.arguments as Book;
        return CupertinoPageRoute(
          builder: (_) => CatalogPage(book: book),
        );
      case RouteName.reader:
        var args = settings.arguments as List;
        Book book = args[0];
        Chapter chapter = args[1];
        return MaterialPageRoute(
          builder: (_) => ReaderScene(book: book, chapter: chapter),
        );
      case RouteName.discovery:
        return CupertinoPageRoute(builder: (_) => const DiscoveryPage());
      case RouteName.checkIn:
        var args =
            settings.arguments == null ? null : settings.arguments as Incentive;
        return CupertinoPageRoute(
          builder: (_) => CheckInPage(incentive: args),
        );
      case RouteName.about:
        return CupertinoPageRoute(builder: (_) => const AboutPage());
      case RouteName.general:
        return CupertinoPageRoute(builder: (_) => const GeneralPage());
      case RouteName.chooseGender:
        return CupertinoPageRoute(builder: (_) => const ChooseGenderPage());
      case RouteName.editNickname:
        return CupertinoPageRoute(builder: (_) => const EditNicknamePage());
      case RouteName.userProfile:
        return CupertinoPageRoute(builder: (_) => const UserProfilePage());
      case RouteName.settings:
        return CupertinoPageRoute(builder: (_) => const SettingsPage());
      case RouteName.help:
        return CupertinoPageRoute(builder: (_) => const HelpPage());
      case RouteName.mine:
        return CupertinoPageRoute(builder: (_) => const MinePage());
      case RouteName.chooseReadingPrefs:
        return CupertinoPageRoute(builder: (_) => ChooseReadingPrefsPage());
      case RouteName.signIn:
        return NoAnimRouteBuilder<bool>(
            page: const SignInPage(), settings: settings);
      case RouteName.text:
        var args = settings.arguments as List;
        String title = args[0];
        String body = args[1];
        return CupertinoPageRoute(
            builder: (_) => TextPage(title: title, body: body));
      case RouteName.image:
        var arg = settings.arguments as String;
        return CupertinoPageRoute(
          builder: (_) => ImagePage(imageUrl: arg),
          settings: settings,
        );
      case RouteName.web:
        var args = settings.arguments as List;
        return CupertinoPageRoute(
          builder: (_) => WebPage(url: args[0], title: args[1]),
          settings: settings,
        );
      case RouteName.home:
        return NoAnimRouteBuilder(page: const HomePage(), settings: settings);
      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Future<bool?> showLoginOptions(BuildContext context) async {
    bool? result = await Navigator.push<bool>(
        context,
        MaterialPageRoute<bool>(
          builder: (_) => const SignInPage(),
        ));
    return Future.value(result);
  }
}

/// Pop路由
class PopRoute extends PopupRoute {
  final Duration _duration = const Duration(milliseconds: 300);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}
