import 'package:novel_flutter/view_model/bookshelf_model.dart';
import 'package:novel_flutter/view_model/incentives_model.dart';
import 'package:novel_flutter/view_model/locale_model.dart';
import 'package:novel_flutter/view_model/navigation_model.dart';
import 'package:novel_flutter/view_model/theme_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

/// 全局提供者
List<SingleChildWidget> providers() {
  List<SingleChildWidget> providers = [];
  providers.addAll(independentServices);
  providers.addAll(dependentServices);
  providers.addAll(uiConsumableProviders);
  return providers;
}

/// 独立的model
List<SingleChildWidget> independentServices = [
  ChangeNotifierProvider<ThemeModel>(
    create: (context) => ThemeModel(),
  ),
  ChangeNotifierProvider<LocaleModel>(
    create: (context) => LocaleModel(),
  ),
  ChangeNotifierProvider<UserModel>(
    create: (context) => UserModel(),
  ),
  ChangeNotifierProvider<BookshelfModel>(
    create: (context) => BookshelfModel(),
  ),
//  ChangeNotifierProvider<NavigationModel>(
//    create: (context) => NavigationModel(Provider.of(context, listen: false)),
//  ),
  ChangeNotifierProvider<IncentivesModel>(
    create: (context) => IncentivesModel(),
  ),
];

/// 需要依赖的model
///
/// localBookshelfModel依赖UserModel
List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<BookshelfModel, NavigationModel>(
    create: (context) => NavigationModel(Provider.of(context, listen: false)),
    update: (context, bookshelfModel, navigationModel) =>
        navigationModel ?? NavigationModel(bookshelfModel),
  ),
];

List<SingleChildWidget> uiConsumableProviders = [
//  StreamProvider<User>(
//    builder: (context) => Provider.of<AuthenticationService>(context, listen: false).user,
//  )
];
