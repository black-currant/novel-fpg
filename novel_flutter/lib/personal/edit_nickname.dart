import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 编辑昵称
class EditNicknamePage extends StatefulWidget {
  const EditNicknamePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EditNicknamePage> {
  late TextEditingController _controller;
  final _focusNode = FocusNode();

  late ValueNotifier<bool> _notifier;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: Provider.of<UserModel>(context, listen: false).user.nickname!,
        selection: TextSelection.fromPosition(
          TextPosition(
              affinity: TextAffinity.downstream,
              offset: Provider.of<UserModel>(context, listen: false)
                  .user
                  .nickname!
                  .length),
        ),
      ),
    );
    _controller.addListener(() {
      _notifier.value = _controller.text.isEmpty;
    });
    _notifier = ValueNotifier(_controller.text.isEmpty);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: horizontalMargin,
      ),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: _controller,
        focusNode: _focusNode,
        onChanged: (value) {},
        autofocus: true,
        cursorColor: Theme.of(context).cursorColor,
        style: Theme.of(context).textTheme.subtitle1,
        maxLines: 1,
        maxLength: 13,
        decoration: InputDecoration(
          suffixIcon: ValueListenableBuilder(
            valueListenable: _notifier,
            builder: (context, bool value, child) {
              return Offstage(
                offstage: value,
                child: child,
              );
            },
            child: IconButton(
              onPressed: () {
                _controller.clear();
              },
              icon: Icon(
                Icons.clear,
                color: Theme.of(context).hintColor,
              ),
            ),
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).editNickname,
        ),
        actions: <Widget>[
          ProviderWidget<UserProfileModel>(
            model: UserProfileModel(
                userModel: Provider.of<UserModel>(context, listen: false)),
            builder: (_, model, child) {
              if (model.isBusy) {
                return IconButton(
                  onPressed: () {},
                  icon: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return IconButton(
                onPressed: () async {
                  String value = _controller.text.trim();
                  if (value.isEmpty) {
                    _focusNode.requestFocus();
                    showToast(S.of(context).pleaseTypeContent);
                    return;
                  }
                  _focusNode.unfocus();

                  await model.update(nickname: value);
                  if (model.isError) {
                    model.showErrorMessage(context);
                    return;
                  }
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
}
