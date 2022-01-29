import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/help/customer_service.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:flutter/material.dart';

/// 帮助与反馈
/// 常见问题
/// 意见反馈
class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

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
                title: Text(S.of(context).feedback),
                onTap: () {
                  if (checkLogin(context: context)) return;
                  // 联系客服
                  showCSCDialog(context);
                },
                trailing: const Icon(Icons.chevron_right),
              ),
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
      appBar: AppBar(
        title: Text(S.of(context).helpAndFeedback),
      ),
      body: _buildBody(context),
    );
  }
}
