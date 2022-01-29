import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/initial_params.dart';
import 'package:novel_flutter/view_model/initial_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oktoast/oktoast.dart';
import 'package:url_launcher/url_launcher.dart';

/// 显示客服中心对话框
void showCSCDialog(BuildContext context) async {
  // 联系客服
  String? weChat;
  String? email;
  showLoadingDialog(context, S.of(context).loadMoreLoading);
  InitialModel model = InitialModel();
  List<InitialParams>? data = await model.fetch();
  closeLoadingDialog(context);
  if (data == null || data.isEmpty) {
    weChat = customerWeChat;
    email = customerEmail;
  } else {
    for (var item in data) {
      if (item.name == kCSCWeChat) {
        weChat = item.option;
      } else if (item.name == kCSCEmail) {
        email = item.option;
      }
    }
  }
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomerServiceDialog(weChat: weChat!, email: email!);
      });
}

/// 客服中心
class CustomerServiceDialog extends Dialog {
  final String weChat;
  final String email;

  const CustomerServiceDialog(
      {Key? key, required this.weChat, required this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Theme.of(context).cardColor,
        child: Container(
          width: 300,
          height: 220,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 48,
                color: Theme.of(context).colorScheme.secondary,
                alignment: Alignment.center,
                child: Text(
                  S.of(context).customerService,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.white),
                ),
              ),
              const SpaceDivider(height: dividerMediumSize),
              Expanded(
                flex: 1,
                child: _buildBody(context),
              ),
              const SizedBox(height: verticalMargin),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: ListTileTheme(
        selectedColor: Theme.of(context).colorScheme.secondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Column(
          children: <Widget>[
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () async {
                  showToast(S.of(context).copy2Clipboard);
                  await Future.delayed(const Duration(seconds: 1));
                  // Launch WeChat
                  launch(urlSchemeWeChat);
                  var data = ClipboardData(text: weChat);
                  Clipboard.setData(data);
                },
                leading: const FaIcon(
                  FontAwesomeIcons.weixin,
                  color: Color(0xFF05BC0B),
                ),
                title: Text(S.of(context).weChat,
                    style: Theme.of(context).textTheme.subtitle1),
                subtitle: Text(
                  'ID:$weChat',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () async {
                  // 打开邮箱
                  try {
                    var url = 'mailto:$email?subject=' +
                        S.of(context).appName +
                        '%20Feedback&body=Say something...';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      showToast(S.of(context).mailClientNotFound);
                    }
                  } catch (e) {
                    print(e);
                  }
                },
                leading: const Icon(
                  Icons.mail,
                  color: Colors.grey,
                ),
                title: Text(S.of(context).email,
                    style: Theme.of(context).textTheme.subtitle1),
                subtitle: Text(
                  email,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
