import 'dart:convert';

import 'package:pomodak/models/domain/member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String memberKey = "6E45EF1G1AUI3E51BD1VG9SD68";

abstract class MemberLocalDataSource {
  MemberModel? getMember();
  Future<void> saveMember(MemberModel member);
  Future<void> deleteMember();
}

class MemberLocalDataSourceImpl implements MemberLocalDataSource {
  final SharedPreferences sharedPreferences;

  MemberLocalDataSourceImpl(this.sharedPreferences);

  @override
  MemberModel? getMember() {
    final jsonString = sharedPreferences.getString(memberKey);
    if (jsonString != null) {
      return MemberModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> saveMember(MemberModel member) async {
    final jsonString = json.encode(member.toJson());
    await sharedPreferences.setString(memberKey, jsonString);
  }

  @override
  Future<void> deleteMember() async {
    await sharedPreferences.remove(memberKey);
  }
}
