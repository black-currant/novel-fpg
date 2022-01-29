import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 选择性别
class ChooseGenderPage extends StatelessWidget {
  const ChooseGenderPage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: ProviderWidget<UserProfileModel>(
        model: UserProfileModel(userModel: Provider.of(context, listen: false)),
        builder: (_, model, child) {
          return ListView.separated(
            padding: const EdgeInsets.only(top: verticalMargin),
            separatorBuilder: (context, index) => const Divider(
              height: dividerLineSize,
              color: Colors.transparent,
            ),
            shrinkWrap: true,
            itemCount: model.genderList.length,
            itemBuilder: (context, index) {
              return RadioListTile<String>(
                value: index.toString(),
                onChanged: (index) async {
                  bool successful =
                      await model.update(gender: index.toString());
                  if (successful) showToast(S.of(context).operationSucceeded);
                },
                groupValue: model.genderIndex,
                title: Text(
                    UserProfileModel.genderName(index.toString(), context)),
              );
            },
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
        title: Text(S.of(context).editGender),
      ),
      body: _buildBody(context),
    );
  }
}
