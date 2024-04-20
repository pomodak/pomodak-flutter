import 'dart:async';

import 'package:pomodak/data/datasources/local/member_local_datasource.dart';
import 'package:pomodak/data/datasources/remote/member_remote_datasource.dart';
import 'package:pomodak/data/repositories/shop_repository.dart';
import 'package:pomodak/models/domain/member_model.dart';
import 'package:pomodak/models/domain/palette_model.dart';
import 'package:pomodak/models/domain/character_inventory_model.dart';
import 'package:pomodak/models/domain/item_inventory_model.dart';

class MemberRepository {
  final MemberLocalDataSource localDataSource;
  final MemberRemoteDataSource remoteDataSource;

  MemberRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Future<MemberModel?> getMember({bool forceUpdate = false}) async {
    try {
      if (!forceUpdate) {
        final localData = localDataSource.getMember();
        if (localData != null) return localData;
      }
      final remoteData = await remoteDataSource.fetchMember();
      if (remoteData != null) {
        await localDataSource.saveMember(remoteData);
      }
      return remoteData;
    } catch (e) {
      localDataSource.deleteMember();
      rethrow;
    }
  }

  Future<PaletteModel?> getMemberPalette(String memberId) async {
    try {
      return await remoteDataSource.fetchMemberPalette(memberId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CharacterInventoryModel>> getMemberCharacterInventory(
    String memberId,
  ) async {
    try {
      return await remoteDataSource.fetchMemberCharacterInventory(memberId);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ItemInventoryModel>> getMemberItemInventory(
    String memberId,
    ItemType itemType,
  ) async {
    try {
      return await remoteDataSource.fetchMemberItemInventory(
        memberId,
        itemType,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMemberInfo(String memberId, String nickname,
      String imageUrl, String statusMessage) async {
    try {
      await remoteDataSource.updateMember(
          memberId, nickname, imageUrl, statusMessage);

      await getMember(forceUpdate: true);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearMemberData() async {
    await localDataSource.deleteMember();
  }
}
