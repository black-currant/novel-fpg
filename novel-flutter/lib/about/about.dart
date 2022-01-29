import 'package:novel_flutter/app/config.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/app/upgrade.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/utils/package_util.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/material.dart';

/// 关于
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<AboutPage> {
  String? _versionName;

  void setup() async {
    _versionName = await PackageUtil.getAppVersionName();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  Widget _buildBody() {
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
                title: Text(S.of(context).upgrade,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () async {
                  checkVersion(context, true);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'V $_versionName',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(S.of(context).termsOfService,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.web,
                      arguments: [termsURL, S.of(context).termsOfService]);
                },
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(S.of(context).privacyPolicy,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.web,
                      arguments: [privacyURL, S.of(context).privacyPolicy]);
                },
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () {
                  productPageInStore();
                },
                title: Text(
                  S.of(context).storeReview,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: S.of(context).appName,
                    applicationVersion: _versionName,
                  );
                },
                title: Text(
                  S.of(context).openSourceLicense,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
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
      appBar: AppBar(title: Text(S.of(context).appName)),
      body: _buildBody(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setup();
  }
}
