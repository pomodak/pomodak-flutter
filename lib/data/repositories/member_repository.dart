import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/data/network/base_api_services.dart';
import 'package:pomodak/data/network/network_api_service.dart';
import 'package:pomodak/models/api/member_response_model.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

String memberKey = "6E45EF1G1AUI3E51BD1VG9SD68";

class MemberRepository {
  final String _nestApiEndpoint = dotenv.env['NEST_API_ENDPOINT']!;
  final BaseApiServices _apiServices = NetworkApiService();

  // 캐시 저장소
  late final SharedPreferences sharedPreferences;

  MemberRepository() {
    _init();
  }
  Future<void> _init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<MemberModel?> fetchMemberData() async {
    try {
      String? memberData = sharedPreferences.getString(memberKey);
      if (memberData != null) {
        print("저장소 데이터 요청");
        return MemberModel.fromJson(json.decode(memberData));
      } else {
        return await _fetchMemberFromApi();
      }
    } catch (e) {
      clearMemberData();
      return null;
    }
  }

  Future<MemberModel?> _fetchMemberFromApi() async {
    try {
      print("서버에서 데이터 요청");
      final response = await _apiServices.getGetApiResponse(
        '$_nestApiEndpoint/members/me',
      );
      var data = MemberResponseData.fromJson(response["data"]);
      await _storeMemberData(data.member);

      return data.member;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _storeMemberData(MemberModel member) async {
    await sharedPreferences.setString(memberKey, json.encode(member.toJson()));
  }

  Future<void> clearMemberData() async {
    await sharedPreferences.remove(memberKey);
  }
}
