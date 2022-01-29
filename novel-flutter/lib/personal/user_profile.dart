import 'package:novel_flutter/app/colors.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/routes.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/utils/util.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:novel_flutter/view_model/user_profile_model.dart';
import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

/// 用户信息
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    UserModel model = Provider.of<UserModel>(context);
    return SingleChildScrollView(
      child: ListTileTheme(
        selectedColor: Theme.of(context).colorScheme.secondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: horizontalMargin,
        ),
        child: Column(
          children: <Widget>[
            Material(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(S.of(context).avatar,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {},
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: ClipOval(
                        child: model.hasUser && model.user.photourl!.isNotEmpty
                            ? Image(
                                image: ExtendedNetworkImageProvider(
                                    model.user.photourl!,
                                    cache: true,
                                    retries: 3,
                                    timeLimit:
                                        const Duration(milliseconds: 100),
                                    timeRetry:
                                        const Duration(milliseconds: 100)),
                                // NetworkImage(model.user.photourl),
                                fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Image.asset(
                                      Util.assetImage('image_placeholder.png'));
                                },
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                      Util.assetImage('image_error.png'));
                                },
                              )
                            : Image.asset(
                                Util.assetImage('avatar.png'),
                                fit: BoxFit.cover,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                      ),
                      padding: const EdgeInsets.all(4),
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
                onTap: () async {
                  showToast(S.of(context).copy2Clipboard);
                  var data = ClipboardData(text: model.user.id.toString());
                  await Clipboard.setData(data);
                },
                title: Text(S.of(context).userID,
                    style: Theme.of(context).textTheme.subtitle1),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      '${model.user.id}',
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
                title: Text(S.of(context).nickname,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.editNickname);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        model.user.nickname!,
                        style: Theme.of(context).textTheme.subtitle2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
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
                title: Text(S.of(context).gender,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.chooseGender);
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      UserProfileModel.genderName(model.user.gender!, context),
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
                title: Text(S.of(context).bookTypePrefs,
                    style: Theme.of(context).textTheme.subtitle1),
                onTap: () {
                  Navigator.of(context).pushNamed(RouteName.editBookTypePrefs);
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
      appBar: AppBar(title: Text(S.of(context).userProfile)),
      body: _buildBody(context),
    );
  }
}
