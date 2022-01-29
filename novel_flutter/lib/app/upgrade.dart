import 'dart:io';

import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/version.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/view_model/upgrade_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import 'package:oktoast/oktoast.dart';

const appUpgradeTag = 'Check upgrade.';

void checkVersion(BuildContext context, bool showLatest) async {
  UpgradeModel model = UpgradeModel();
  Version? data = await model.request();
  if (data == null || model.isError) {
    if (showLatest) model.showErrorMessage(context);
    return;
  }
  int localVer = await PackageUtil.getAppVersionCode();
  int latestVer = data.versionCode;
  print('$appUpgradeTag latest version code $latestVer.');
  if (latestVer > localVer) {
    showUpgradeAppDialog(context, data);
  } else {
    if (showLatest) showToast(S.of(context).currentlyLatestVersion);
  }
}

void showUpgradeAppDialog(BuildContext context, Version data) {
  var title = Text(
    S.of(context).appUpgrade,
    style: Theme.of(context).textTheme.headline6,
  );
  var content = SingleChildScrollView(
    child: ListBody(
      children: <Widget>[
        Text(
          S.of(context).jumpToUpdateInStore, // data.desc,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    ),
  );
  var positiveText = Text(S.of(context).ok,
      style: Theme.of(context)
          .textTheme
          .button!
          .copyWith(color: Theme.of(context).colorScheme.secondary));
  onPositiveTap() {
    downloadAPPByStore(data);
    if (!data.isForced) {
      Navigator.pop(context);
    }
  }

  var negativeText = Visibility(
    child:
        Text(S.of(context).cancel, style: Theme.of(context).textTheme.button),
    visible: !data.isForced,
  );
  onNegativeTap() {
    Navigator.pop(context);
  }

  if (Platform.isAndroid) {
    var actions = <Widget>[
      TextButton(onPressed: onNegativeTap, child: negativeText),
      TextButton(onPressed: onPositiveTap, child: positiveText),
    ];
    if (data.isForced) {
      actions.removeAt(0);
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: title,
            content: content,
            actions: actions,
          );
        });
  } else if (Platform.isIOS) {
    var actions = <Widget>[
      CupertinoDialogAction(onPressed: onNegativeTap, child: negativeText),
      CupertinoDialogAction(onPressed: onPositiveTap, child: positiveText),
    ];
    if (data.isForced) {
      actions.removeAt(0);
    }
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: actions,
          );
        });
  }
}

/// 通过商店下载APP
void downloadAPPByStore(Version data) async {
  productPageInStore();
}

/// 通过URL下载APP
void downloadAPPByURL(Version data) async {}

/// 打开商店，显示应用详情页
void productPageInStore() async {
  var packageName = await PackageUtil.getPackageName();
  LaunchReview.launch(androidAppId: packageName, iOSAppId: appIdOfAppStore);
}
