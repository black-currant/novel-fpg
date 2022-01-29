import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/mine.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/upgrade.dart';
import 'package:novel_flutter/bookshelf/bookshelf.dart';
import 'package:novel_flutter/bookstore/bookstore.dart';
import 'package:novel_flutter/discovery/discovery.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book.dart';
import 'package:novel_flutter/model/chapter.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/navigation_model.dart';
import 'package:novel_flutter/view_model/online_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// APP顶层小部件
class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  /// TAB页面，
  /// 通过mixin AutomaticKeepAliveClientMixin实现切换tab页面状态保存
  final _pages = <Widget>[
    const BookshelfPage(),
    const BookstorePage(),
    const DiscoveryPage(),
    const MinePage(),
  ];

  DateTime? _lastPressed;
  bool isFinishSetup = false;

  /// 跳最近页面
  /// 如果上一次退出app的最后一个界面是阅读界面，那么下次进入自动回到阅读状态。
  void jumpRecentPage() async {
    int? userId = Persistence.sharedPreferences.getInt(kUserId);
    if (userId == null) return;
    String key = kRecentRoute(userId);
    debugPrint('Recent route key $key.');
    String routeName = Persistence.sharedPreferences.getString(key) ?? '';
    debugPrint('Recent route $routeName.');
    if (routeName == RouteName.reader) {
      var map = Persistence.localStorage.getItem(kRecentBook(userId));
      Book book = Book.fromJson(map);
      debugPrint('Recent route book ${book.title}.');
      Chapter chapter = lastReadingRecords(book.id!);
//      await Future.delayed(Duration(milliseconds: 2500));
      Navigator.of(context)
          .pushNamed(RouteName.reader, arguments: [book, chapter]);
    }
  }

  /// 同步上线状态
  void online() async {
    var username = Persistence.sharedPreferences.getString(kLoginedUsername);
    var password = Persistence.sharedPreferences.getString(kLoginedPassword);
    if (username == null || password == null) return;
    User param = User();
    param.account = username;
    param.password = password;
    debugPrint('Online param provider ${param.provider}.');
    OnlineModel model = OnlineModel();
    bool successful = await model.request(param);
    debugPrint('Online result $successful');
  }

  void setup() async {
    online(); // 需要context
    checkVersion(context, false);
  }

  @override
  void initState() {
    super.initState();
    setup();
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      // 页面构建完毕
      jumpRecentPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<NavigationModel>(
      autoDispose: false,
      model: Provider.of<NavigationModel>(context, listen: false),
      builder: (_, model, child) {
        debugPrint('Home widget build.');
        return Scaffold(
          //      key: _scaffoldKey,
          body: WillPopScope(
              onWillPop: () async {
                if (_lastPressed == null ||
                    DateTime.now().difference(_lastPressed!) >
                        const Duration(seconds: 1)) {
                  //两次点击间隔超过1秒则重新计时
                  _lastPressed = DateTime.now();
                  return false;
                }
                return true;
              },
              child: IndexedStack(
                children: _pages,
                index: model.selectedIndex,
              )),
          bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              model.select(index);
            },
            iconSize: 24.0,
            selectedFontSize: 12.0,
            unselectedFontSize: 12.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: model.selectedIndex,
            selectedItemColor: Theme.of(context).colorScheme.secondary,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Image.asset(Util.assetImage('bookshelf_off.png')),
                activeIcon: Image.asset(Util.assetImage('bookshelf_on.png')),
                label: S.of(context).bookshelf,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(Util.assetImage('bookcity_off.png')),
                activeIcon: Image.asset(Util.assetImage('bookcity_on.png')),
                label: S.of(context).bookStore,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(Util.assetImage('welfare_off.png')),
                activeIcon: Image.asset(Util.assetImage('welfare_on.png')),
                label: S.of(context).welfare,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(Util.assetImage('mine_off.png')),
                activeIcon: Image.asset(Util.assetImage('mine_on.png')),
                label: S.of(context).mine,
              ),
            ],
          ),
        );
      },
    );
  }
}
