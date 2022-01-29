import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/book_channel.dart';
import 'package:novel_flutter/model/book_type.dart';
import 'package:novel_flutter/personal/edit_book_type_prefs.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_types_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/widgets/action_button.dart';
import 'package:provider/provider.dart';

/// 选择阅读偏好
class ChooseReadingPrefsPage extends StatelessWidget {
  final List<BookType> _selectedChoices = [];

  ChooseReadingPrefsPage({Key? key}) : super(key: key);

  Widget _buildNextButton(BuildContext context) {
    return ProviderWidget<UserProfileModel>(
      model: UserProfileModel(userModel: Provider.of(context, listen: false)),
      builder: (_, model, child) {
        return ActionButton.expand(
          label: S.of(context).enterTheApplication,
          onPressed: () async {
            int preference = 0;
            for (var item in _selectedChoices) {
              preference = item.code! | preference;
            }
            await model.update(preference: preference);
            if (model.isError) {
              model.showErrorMessage(context);
              return;
            }
            Navigator.of(context).pushReplacementNamed(RouteName.home);
          },
          isProgress: model.isBusy,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: verticalMargin,
          horizontal: horizontalMargin,
        ),
        child: ProviderWidget<BookTypesModel>(
          model: BookTypesModel(
            channelId: BookChannel.all,
            languageTag: Localizations.localeOf(context).toLanguageTag(),
          ),
          onModelReady: (model) => model.initData(),
          builder: (context, model, child) {
            if (model.isBusy) {
              return ViewStateBusyWidget();
            } else if (model.isError) {
              return ViewStateErrorWidget(
                  error: model.viewStateError!, onPressed: model.initData);
            } else if (model.isEmpty) {
              return ViewStateEmptyWidget(onPressed: model.initData);
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  S.of(context).bookTypePrefsSlogan,
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 20),
                MultiChoiceBookType(
                  reportList: model.list,
                  onChoiceChanged: (selectedChoices) {
                    _selectedChoices.clear();
                    _selectedChoices.addAll(selectedChoices);
                  },
                ),
                const SizedBox(height: 20),
                _buildNextButton(context),
              ],
            );
          },
        ));
  }

  void onClosed(BuildContext context) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteName.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).bookTypePrefs),
        centerTitle: true,
        actions: <Widget>[
          CloseButton(
            onPressed: () {
              onClosed(context);
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () {
          onClosed(context);
          return Future.value(false);
        },
        child: _buildBody(context),
      ),
    );
  }
}
