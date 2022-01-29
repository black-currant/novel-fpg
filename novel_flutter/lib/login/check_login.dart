import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/app/platformizations.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/utils/platform_util.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';

/// 未登录返回true
bool checkLogin({BuildContext? context}) {
  var userId = Persistence.sharedPreferences.getInt(kUserId);
  if (userId == null && context != null) {
    var content = Text(
      S.of(context).notYetLoginMsg(PlatformUtil.getOperatingSystem()),
      style: Theme.of(context).textTheme.subtitle1,
    );
    var positiveText = Text(
      S.of(context).ok,
      style: Theme.of(context)
          .textTheme
          .button!
          .copyWith(color: Theme.of(context).colorScheme.secondary),
    );
    onPositiveTap() {
      Navigator.pop(context);
      return MyRouter.showLoginOptions(context);
    }

    platformizations.showAlertDialog(
        context: context,
        content: content,
        positiveText: positiveText,
        onPositiveTap: onPositiveTap);
  }
  return userId == null;
}
