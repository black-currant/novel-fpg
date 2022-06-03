import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/http_client.dart';
import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/platformizations.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/view_model/online_model.dart';
import 'package:novel_flutter/widgets/login_form_field.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/login/view_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/widgets/action_button.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 用户登录
class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SignInPage> {
  final _usernameController = TextEditingController();
  final _usernameFocusNode = FocusNode();

  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((callback) {
      // 页面构建完毕
      platformizations.screen(context);
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();

    _passwordController.dispose();
    _passwordFocusNode.dispose();

    super.dispose();
  }

  void unfocusAllFeild() {
    _usernameFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  Widget _buildButton(BuildContext context) {
    return ProviderWidget<SignInViewModel>(
      model: SignInViewModel(
          userModel: Provider.of<UserModel>(context, listen: false)),
      builder: (context, model, child) {
        return ActionButton.expand(
          label: S.of(context).signIn,
          isProgress: model.isBusy,
          onPressed: () async {
            String username = _usernameController.text.trim();
            String password = _passwordController.text.trim();

            if (username.isEmpty) {
              _usernameFocusNode.requestFocus();
              showToast(S.of(context).pleaseTypeAccount);
              return;
            }
            _usernameFocusNode.unfocus();

            if (password.isEmpty) {
              _passwordFocusNode.requestFocus();
              showToast(S.of(context).pleaseTypePassword);
              return;
            }
            _passwordFocusNode.unfocus();

            password = Util.generateMd5(password); // 密码编码
            await model.login(username, password);
            if (model.isError) {
              model.showErrorMessage(context);
              return;
            }
            await Persistence.sharedPreferences
                .setString(kLoginedUsername, username);
            await Persistence.sharedPreferences
                .setString(kLoginedPassword, password);
            nextPageAfterSucceededLogin(context);
          },
        );
      },
    );
  }

  /// 登录成功后清空路由，新用户显示选择阅读喜好
  void nextPageAfterSucceededLogin(BuildContext context) async {
    http.refreshToken(); // 刷新token
    UserModel model = Provider.of(context, listen: false);
    if (model.user.preference == 0) {
      Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.chooseReadingPrefs, (route) => false);
    } else {
//    if (Navigator.canPop(context)) {
//      Navigator.pop(context, true);
//    } else {
//      Navigator.pushNamed(context, RouteName.home);
//    }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteName.home, (route) => false);
    }
  }

  void onBackPressed(BuildContext context) {
    unfocusAllFeild();
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return
        // WillPopScope(
        //   onWillPop: () {
        //     onBackPressed();
        //     return Future.value(true);
        //   },
        //   child:
        Scaffold(
      appBar: AppBar(title: Text(S.of(context).signIn)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: verticalMargin,
          horizontal: horizontalMargin,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LoginFormField(
              hintText: S.of(context).usernameHint,
              prefixIcon: Icons.person,
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              autofocus: true,
              focusNode: _usernameFocusNode,
            ),
            LoginFormField(
              hintText: S.of(context).passwordHint,
              prefixIcon: Icons.password,
              controller: _passwordController,
              obscureText: true,
              visibly: true,
              textInputAction: TextInputAction.done,
              focusNode: _passwordFocusNode,
            ),
            const SpaceDivider(height: dividerMediumSize),
            _buildButton(context),
            const SpaceDivider(height: dividerLargeSize),
          ],
        ),
      ),
      // ),
    );
  }
}
