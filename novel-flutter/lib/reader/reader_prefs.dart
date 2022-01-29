import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/reader_prefs_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 阅读器偏好选项
///
class ReaderPrefs extends StatefulWidget {
  const ReaderPrefs({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ReaderPrefs> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: ProviderWidget<ReaderPrefsModel>(
        autoDispose: false,
        model: ReaderPrefsModel(),
        builder: (_, model, child) {
          return ListTileTheme(
            selectedColor: Theme.of(context).colorScheme.secondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: horizontalMargin,
            ),
            child: Column(
              children: <Widget>[
                Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    title: Text(S.of(context).readerWakeLock,
                        style: Theme.of(context).textTheme.subtitle1),
                    trailing: CupertinoSwitch(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: model.wakelock,
                        onChanged: (value) {
                          model.wakelock = value;
                          setState(() {});
                        }),
                  ),
                ),
                const SpaceDivider(height: dividerLineSize),
                Material(
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    title: Text(S.of(context).automaticRenewal,
                        style: Theme.of(context).textTheme.subtitle1),
                    trailing: CupertinoSwitch(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        value: model.automaticRenewal,
                        onChanged: (value) {
                          model.automaticRenewal = value;
                          setState(() {});
                        }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tilePageBgColor(context),
      appBar: AppBar(
        title: Text(
          S.of(context).readerPrefs,
        ),
      ),
      body: _buildBody(),
    );
  }
}
