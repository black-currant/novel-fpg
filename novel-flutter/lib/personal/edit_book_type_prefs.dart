import 'dart:math';

import 'package:novel_flutter/app/platformizations.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/login/check_login.dart';
import 'package:novel_flutter/model/book_channel.dart';
import 'package:novel_flutter/model/book_type.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/provider/view_state_widget.dart';
import 'package:novel_flutter/view_model/book_types_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:novel_flutter/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/widgets/skeleton.dart';
import 'package:provider/provider.dart';

/// 编辑阅读喜好
class EditBookTypePrefsPage extends StatefulWidget {
  const EditBookTypePrefsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<EditBookTypePrefsPage> {
  final List<BookType> _selectedChoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).bookTypePrefs,
        ),
        actions: <Widget>[
          ProviderWidget<UserProfileModel>(
            model: UserProfileModel(
                userModel: Provider.of(context, listen: false)),
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
                  if (checkLogin(context: context)) return;
                  int preference = 0;
                  for (var item in _selectedChoices) {
                    preference = item.code! | preference;
                  }
                  await model.update(preference: preference);
                  if (model.isError) {
                    model.showErrorMessage(context);
                    return;
                  }
                  var content =
                      Text(S.of(context).changeSuccessfulAndBookTypePrefs);
                  onPositiveTap() {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  }

                  platformizations.showAlertDialog(
                      context: context,
                      content: content,
                      onPositiveTap: onPositiveTap,
                      onNegativeTap: null);
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

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: pageEdgeInsets,
      child: ProviderWidget<BookTypesModel>(
        model: BookTypesModel(
            channelId: BookChannel.all,
            languageTag: Localizations.localeOf(context).toLanguageTag()),
        onModelReady: (model) => model.initData(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return ListShimmer(
              separatorBuilder: (context, index) => spaceDividerMedium,
              padding: pageEdgeInsets,
              itemCount: 9,
              item: const OrderSkeleton(),
            );
            // GridShimmer(
            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 4,
            //     childAspectRatio: 4.0,
            //     crossAxisSpacing: 20,
            //     mainAxisSpacing: dividerMediumSize,
            //   ),
            //   padding: EdgeInsets.symmetric(
            //     vertical: verticalMargin,
            //     horizontal: 24,
            //   ),
            //   itemCount: 48,
            //   item: SizeSkeleton(),
            // );
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
              const SpaceDivider.large(),
              MultiChoiceBookType(
                reportList: model.list,
                onChoiceChanged: (selectedChoices) {
                  _selectedChoices.clear();
                  _selectedChoices.addAll(selectedChoices);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 书籍类型
class MultiChoiceBookType extends StatefulWidget {
  final List<BookType> reportList;

  final Function(List<BookType>) onChoiceChanged;

  const MultiChoiceBookType(
      {Key? key, required this.reportList, required this.onChoiceChanged})
      : super(key: key);

  @override
  _MultiChoiceBookTypeState createState() => _MultiChoiceBookTypeState();
}

class _MultiChoiceBookTypeState extends State<MultiChoiceBookType> {
  List<BookType> selectedItem = [];
  int readingPrefs = 0;

  @override
  void initState() {
    super.initState();
    UserModel userModel = Provider.of(context, listen: false);
    if (userModel.hasUser) {
      readingPrefs = userModel.user.preference!;
      for (var item in widget.reportList) {
        if (item.code! & readingPrefs != 0) selectedItem.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 20,
      crossAxisSpacing: 18,
      childAspectRatio: 3 / 2,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: _buildChips(),
    ));
  }

  _buildChips() {
    List<Widget> chips = [];
    for (var item in widget.reportList) {
      chips.add(ChoiceChip(
        label: Text(item.category!),
        labelStyle: const TextStyle(color: Colors.white),
        selectedColor: Theme.of(context).colorScheme.secondary,
        disabledColor: Colors.black,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        selected: selectedItem.contains(item),
        onSelected: (selected) {
          setState(() {
            selectedItem.contains(item)
                ? selectedItem.remove(item)
                : selectedItem.add(item);
            widget.onChoiceChanged(selectedItem);
          });
        },
      ));
    }
    return chips;
  }
}

class OrderSkeleton extends StatelessWidget {
  const OrderSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizeSkeleton(
          width: Random.secure().nextDouble() * width,
          height: 20,
        ),
        const SpaceDivider.medium(),
        SizeSkeleton(
          width: Random.secure().nextDouble() * width,
          height: 18,
        ),
        const SpaceDivider.medium(),
        SizeSkeleton(
          width: Random.secure().nextDouble() * width,
          height: 10,
        ),
      ],
    );
  }
}
