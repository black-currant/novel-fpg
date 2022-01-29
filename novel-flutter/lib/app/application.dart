import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/provider_manager.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/view_model/locale_model.dart';
import 'package:novel_flutter/view_model/theme_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MultiProvider(
            providers: providers(),
            child: Consumer2<LocaleModel, ThemeModel>(
              builder: (context, localeModel, themeModel, child) {
                return RefreshConfiguration(
                  hideFooterWhenNotFull: true, //列表数据不满一页，不触发加载更多
                  child: MaterialApp(
                    title: 'Flutter Novel',
                    onGenerateTitle: (context) {
                      // Localizations.localeOf(context).toLanguageTag()
                      debugPrint(
                          'Localizations.localeOf(context) = ${Localizations.localeOf(context)}');
                      return S.of(context).appName;
                    },
                    localizationsDelegates: const [
                      // ... app-specific localization delegate[s] here
                      S.delegate,
                      RefreshLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    supportedLocales: S.delegate.supportedLocales,
                    theme: themeModel.theme,
                    darkTheme: themeModel.darkTheme,
                    debugShowCheckedModeBanner: false,
                    // 调试标记
                    showPerformanceOverlay: false,
                    // 性能信息
                    onGenerateRoute: onGenerateRoute,
                    initialRoute: initialRoute(context),
                    navigatorObservers: [routeObserver],
                  ),
                );
              },
            )));
  }

  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MyRouter.generateRoute(
      settings: settings,
    );
  }

  String initialRoute(BuildContext context) {
    int? userId = Persistence.sharedPreferences.getInt(kUserId);
    if (userId == null) {
      return RouteName.signIn;
    } else {
      return RouteName.home;
    }
  }
}

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

/// 保存最近路由
void saveRecentRoute(String routeName) async {
  int? userId = Persistence.sharedPreferences.getInt(kUserId);
  Persistence.sharedPreferences.setString(kRecentRoute(userId!), routeName);
}

/// 全局路由观察者
class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      debugPrint('RouteObserver ${route.settings.name}');
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      debugPrint('RouteObserver ${newRoute.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      debugPrint('RouteObserver ${previousRoute.settings.name}');
    }
  }
}
