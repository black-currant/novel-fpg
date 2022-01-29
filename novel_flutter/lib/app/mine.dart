import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/refresher_footer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// '我的'页面
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MinePage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    debugPrint('$lifeCycleTag $this initState');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    debugPrint('$lifeCycleTag $this didChangeDependencies');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(MinePage oldWidget) {
    debugPrint('$lifeCycleTag $this didUpdateWidget');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    debugPrint('$lifeCycleTag $this dispose');
    super.dispose();
  }

  @override
  void deactivate() {
    debugPrint('$lifeCycleTag $this deactivate');
    super.deactivate();
  }

  Widget _buildGeneralInfo() {
    return ListTileTheme(
      selectedColor: Theme.of(context).colorScheme.secondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: itemPadding),
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.settings);
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(Util.assetImage('settings.png')),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                Text(
                  S.of(context).prefs,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () async {
              var packageName = await PackageUtil.getPackageName();
              LaunchReview.launch(
                  androidAppId: packageName, iOSAppId: appIdOfAppStore);
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(Util.assetImage('like.png')),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                Text(
                  S.of(context).review,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.help);
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(Util.assetImage('help.png')),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                Text(
                  S.of(context).helpAndFeedback,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingInfo() {
    return ListTileTheme(
      selectedColor: Theme.of(context).colorScheme.secondary,
      contentPadding: const EdgeInsets.symmetric(horizontal: itemPadding),
      child: Column(
        children: <Widget>[
//          ListTile(
//            onTap: () {},
//            leading: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Image(
//                  image: AssetImage(Util.assetImage('task.png')),
//                  color: Theme.of(context).colorScheme.secondary,
//                ),
//                SizedBox(
//                  width: 10,
//                ),
//                Text('我的任务'),
//              ],
//            ),
//            trailing: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Text('做任务，领取福利'),
//                Icon(Icons.chevron_right),
//              ],
//            ),
//          ),
//          ListTile(
//            onTap: () {},
//            leading: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Image(
//                  image: AssetImage(Util.assetImage('reading_plan.png')),
//                  color: Theme.of(context).colorScheme.secondary,
//                ),
//                SizedBox(
//                  width: 10,
//                ),
//                Text('我的阅读计划'),
//              ],
//            ),
//            trailing: Row(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Text('2本'),
//                Icon(Icons.chevron_right),
//              ],
//            ),
//          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, RouteName.editBookTypePrefs);
            },
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image(
                  image: AssetImage(Util.assetImage('reading_prefs.png')),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 10),
                Text(
                  S.of(context).bookTypePrefs,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletInfo() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(itemPadding),
      child: ProviderWidget<UserModel>(
        autoDispose: false,
        model: Provider.of(context, listen: false),
        builder: (_, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  if (checkLogin(context: context)) return;
                  Navigator.of(context).pushNamed(RouteName.wallet);
                },
                child: SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              style: Theme.of(context).textTheme.subtitle1,
                              text: S.of(context).virtualCurrency + ' ',
                            ),
                            TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                              text: model.hasUser ? '${model.user.score}' : '0',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
//          GridView.count(
//            crossAxisCount: 3,
//            mainAxisSpacing: 0,
//            crossAxisSpacing: 10,
//            childAspectRatio: 5 / 2,
//            physics: const NeverScrollableScrollPhysics(),
//            shrinkWrap: true,
//            children: <Widget>[
//              _buildWalletItem(0, '推荐票', 0),
//              _buildWalletItem(0, '月票', 1),
//              _buildWalletItem(0, '优惠券', 2),
//            ],
//          ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Column(
          children: <Widget>[
            const SpaceDivider(height: dividerMediumSize),
            Container(
              decoration: itemDecoration(context: context),
              child: _buildWalletInfo(),
            ),
            const SpaceDivider(height: dividerMediumSize),
            Container(
              decoration: itemDecoration(context: context),
              child: _buildReadingInfo(),
            ),
            const SpaceDivider(height: dividerMediumSize),
            Container(
              decoration: itemDecoration(context: context),
              child: _buildGeneralInfo(),
            ),
            SpaceDivider(height: MediaQuery.of(context).size.height / 3),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('$lifeCycleTag $this build');
    super.build(context);
    RefreshController refreshController =
        RefreshController(initialRefresh: false);
    return Scaffold(
      body: ProviderWidget<UserProfileModel>(
        model: UserProfileModel(
            userModel: Provider.of<UserModel>(context, listen: false)),
//        onModelReady: (model) {
//          if (checkLogin()) return;
//          model.fetch(); // 最好是切换到mine tab时自动调用刷新数据
//        },
        builder: (_, model, child) {
          return SmartRefresher(
            controller: refreshController,
            header: WaterDropHeader(
              waterDropColor: Theme.of(context).colorScheme.secondary,
            ),
            footer: const RefresherFooter(),
            enablePullDown: !checkLogin(),
            onRefresh: () async {
              await model.fetch();
              refreshController.refreshCompleted();
            },
            enablePullUp: false,
            child: CustomScrollView(
              slivers: <Widget>[
                _MyAppBar(),
                _buildBody(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MyAppBar extends StatefulWidget {
  @override
  State createState() => _MyAppBarState();
}

class _MyAppBarState extends State<_MyAppBar>
    with SingleTickerProviderStateMixin {
  var _sliverAppBarTop = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildUserInfo() {
    return Center(
      child: ProviderWidget<UserModel>(
        autoDispose: false,
        model: Provider.of(context, listen: false),
        builder: (context, model, child) {
          String readingTime = model.hasUser ? '${model.user.duration}' : '0';
          return InkWell(
            onTap: () {
              model.hasUser
                  ? Navigator.of(context).pushNamed(RouteName.userProfile)
                  : MyRouter.showLoginOptions(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                ClipOval(
                  child: model.hasUser && model.user.photourl!.isNotEmpty
                      ? Image(
                          image: NetworkImage(model.user.photourl!),
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                        )
                      : Image(
                          image: AssetImage(Util.assetImage('avatar.png')),
                          fit: BoxFit.cover,
                          height: 80,
                          width: 80,
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    model.hasUser
                        ? model.getNickname(context)
                        : S.of(context).signIn,
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  model.hasUser
                      ? (S.of(context).thisWeekRead +
                          readingTime +
                          S.of(context).minutes)
                      : '',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlexibleSpace() {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                isDark ? Colors.black12 : Colors.white70,
                const Color(0xFF48e0b8)
              ],
            ),
          ),
        ),
        _buildUserInfo(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 180.0,
      elevation: Theme.of(context).appBarTheme.elevation,
      floating: false,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (_, constraints) {
          _sliverAppBarTop = constraints.biggest.height;
          return FlexibleSpaceBar(
            centerTitle: true,
            title: AnimatedOpacity(
              duration: const Duration(milliseconds: 0),
              opacity: _sliverAppBarTop <= ScreenUtil.appBarAndSysBarHeight
                  ? 1.0
                  : 0.0,
              child: Text(
                S.of(context).mine,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            background: _buildFlexibleSpace(),
          );
        },
      ),
      actions: <Widget>[
        IconButton(
          padding: const EdgeInsets.all(0.0),
          icon: Image.asset(
            Util.assetImage("check_in.png"),
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            if (checkLogin(context: context)) return;
            Navigator.of(context).pushNamed(RouteName.checkIn);
          },
        ),
        // IconButton(
        //   padding: EdgeInsets.all(0.0),
        //   icon: Image.asset(
        //     Util.assetImage("notifications.png"),
        //     color: Color(0xFF666666),
        //   ),
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(RouteName.notifications);
        //   },
        // ),
        const SizedBox(width: horizontalMargin),
      ],
    );
  }
}
