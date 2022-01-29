import 'package:novel_flutter/app/persistence.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:flutter/material.dart';

/// 登录之后保存信息
const String kUser = 'user';
const String kUserId = 'userId';
const String kAccessToken = 'accessToken';

/// 用户信息
class UserModel extends ViewStateModel {
  User? _user;

  User get user => _user!;

  bool get hasUser => _user != null;

  UserModel() {
    var map = Persistence.localStorage.getItem(kUser);
    _user = map != null ? User.fromJson(map) : null;
  }

  save(User user) {
    _user = user;
    debugPrint('Save user id ${user.id},token ${user.token}.');
    notifyListeners();
    Persistence.localStorage.setItem(kUser, user);
    Persistence.sharedPreferences.setInt(kUserId, user.id!);
    Persistence.sharedPreferences.setString(kAccessToken, user.token!);
  }

  /// 清除保存的用户数据
  clear() {
    _user = null;
    notifyListeners();
    Persistence.localStorage.deleteItem(kUser);
    Persistence.sharedPreferences.remove(kUserId);
    Persistence.sharedPreferences.remove(kAccessToken);
  }

  String getNickname(BuildContext context) {
    return user.nickname!.isEmpty
        ? S.of(context).notSetNickname
        : user.nickname!;
  }
}
