import 'package:novel_flutter/app/constant.dart';
import 'package:novel_flutter/app/server_api.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/model/user.dart';
import 'package:novel_flutter/provider/view_state_model.dart';
import 'package:novel_flutter/view_model/user_model.dart';
import 'package:flutter/material.dart';

/// 编辑用户信息
class UserProfileModel extends ViewStateModel {
  final UserModel userModel;
  late User _user;

  UserProfileModel({required this.userModel}) {
    _user = userModel.user;
  }

  get user => _user;

  /// 获取用户信息
  Future<bool> fetch() async {
    setBusy();
    try {
      _user = await serverAPI.userProfile();
      // 更新缓存的用户信息
      // 此接口未返回token
      var token = userModel.user.token;
      _user.token = token;
      userModel.save(_user);

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  /// 更新
  Future<bool> update({
    String? photoUrl,
    String? nickname,
    String? gender,
    int? preference,
  }) async {
    setBusy();
    try {
      bool successful = await serverAPI.updateUserProfile(
        nickname: nickname,
        gender: gender,
        photoUrl: photoUrl,
        preference: preference,
      );
      if (!successful) return false;

      _user = userModel.user;
      if (photoUrl != null) _user.photourl = photoUrl;
      if (nickname != null) _user.nickname = nickname;
      if (gender != null) _user.gender = gender;
      if (preference != null) _user.preference = preference;
      // 更新缓存的用户信息
      userModel.save(_user);

      setIdle();
      return true;
    } catch (e, s) {
      setError(e, s);
      return false;
    }
  }

  String get genderIndex => _user.gender!.isEmpty ? '0' : _user.gender!;

  final genderList = [
    Gender.unknown,
    Gender.male,
    Gender.female,
  ];

  static String genderName(String index, BuildContext context) {
    switch (index) {
      case '0':
        return S.of(context).keepSecret;
      case '1':
        return S.of(context).male;
      case '2':
        return S.of(context).female;
      default:
        return S.of(context).unknown;
    }
  }

  String genderValue(Gender gender) {
    switch (gender) {
      case Gender.unknown:
        return '0';
      case Gender.female:
        return '2';
      case Gender.male:
        return '1';
      default:
        return '0';
    }
  }
}
