import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/view_model/locale_model.dart';
import 'package:novel_flutter/view_model/theme_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 通用设置
class GeneralPage extends StatelessWidget {
  const GeneralPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    var localeModel = Provider.of<LocaleModel>(context);
    var themeModel = Provider.of<ThemeModel>(context);
    return SingleChildScrollView(
      child: ListTileTheme(
        selectedColor: Theme.of(context).colorScheme.secondary,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: horizontalMargin),
        child: Column(
          children: <Widget>[
            Material(
              color: Theme.of(context).cardColor,
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).multiLanguage,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      localeModel.currentLabel(context),
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
                leading: Icon(
                  Icons.language,
                  size: leadingIcon,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: localeModel.localeLength,
                      itemBuilder: (context, index) {
                        return RadioListTile<int>(
                          value: index,
                          onChanged: (index) {
                            localeModel.switchLocale(index);
                          },
                          groupValue: localeModel.localeIndex,
                          title: Text(localeModel.localeLabel(index, context)),
                        );
                      })
                ],
              ),
            ),
            const SpaceDivider(height: dividerLineSize),
            Material(
              color: Theme.of(context).cardColor,
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S.of(context).skin,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    Text(
                      themeModel.currentAppearanceLabel(context),
                      style: Theme.of(context).textTheme.subtitle2,
                    )
                  ],
                ),
                leading: Icon(
                  Icons.settings_brightness,
                  size: leadingIcon,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                children: <Widget>[
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: themeModel.appearancesLength,
                    itemBuilder: (context, index) {
                      return RadioListTile<int>(
                        value: index,
                        onChanged: (index) {
                          themeModel.switchTheme(appearanceIndex: index);
                        },
                        groupValue: themeModel.appearanceIndex,
                        title: Text(
                          themeModel.appearanceLabel(index, context),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      );
                    },
                  )
                ],
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
        title: Text(
          S.of(context).general,
        ),
      ),
      body: _buildBody(context),
    );
  }
}

void switchDarkMode(BuildContext context) {
  /// 确定设置为Dark模式
  int appearance = Theme.of(context).brightness == Brightness.light
      ? appearanceDark
      : appearanceLight;
//  Navigator.of(context).pushNamed(RouteName.darkLoading, arguments: darkModel);
  Provider.of<ThemeModel>(context, listen: false)
      .switchTheme(appearanceIndex: appearance);
//    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
//      showToast("检测到系统为暗黑模式,已为你自动切换", position: ToastPosition.bottom);
//    } else {
//    }
}
