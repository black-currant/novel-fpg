import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/http_client.dart';
import 'package:novel_flutter/app/platformizations.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/view_model/logout_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 成功退出帐号后，清空路由，返回首页
void nextPageAfterSucceededLogout(BuildContext context) {
  http.refreshToken();
  Navigator.of(context)
      .pushNamedAndRemoveUntil(RouteName.signIn, (route) => false);
}

/// APP设置
class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  /// 清理缓存
  /// clearDiskCachedImages

  /// 退出帐号点击事件
  void onLogoutTap(BuildContext context, LogoutModel model) {
    var content = Text(S.of(context).areYouSureToLogout);
    onPositiveTap() async {
      Navigator.pop(context); // 关闭对话框
      showLoadingDialog(context, S.of(context).logout);
      await model.request();
      closeLoadingDialog(context);
      if (model.isError) {
        model.showErrorMessage(context);
        return;
      }
      nextPageAfterSucceededLogout(context);
    }

    platformizations.showAlertDialog(
        context: context, content: content, onPositiveTap: onPositiveTap);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: ListTileTheme(
        selectedColor: Theme.of(context).colorScheme.secondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Offstage(
              offstage: !Provider.of<UserModel>(context, listen: false).hasUser,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(S.of(context).userProfile,
                          style: Theme.of(context).textTheme.subtitle1),
                      onTap: () {
                        if (checkLogin(context: context)) return;
                        Navigator.of(context).pushNamed(RouteName.userProfile);
                      },
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  ),
                  const SpaceDivider(height: dividerMediumSize),
                ],
              ),
            ),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(S.of(context).readerPrefs,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.readerPrefs);
                },
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(S.of(context).about,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.about);
                },
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerMediumSize),
            ProviderWidget<LogoutModel>(
              model: LogoutModel(Provider.of(context, listen: false)),
              builder: (_, model, child) {
                return Visibility(
                  visible: model.userModel.hasUser,
                  child: Material(
                    color: Theme.of(context).cardColor,
                    child: ListTile(
                      title: Text(
                        S.of(context).logout,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onTap: () => onLogoutTap(context, model),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tilePageBgColor(context),
      appBar: AppBar(title: Text(S.of(context).prefs)),
      body: _buildBody(context),
    );
  }
}
