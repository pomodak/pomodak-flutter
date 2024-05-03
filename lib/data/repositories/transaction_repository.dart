import 'dart:async';

import 'package:pomodak/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:pomodak/models/api/shop/reward_points_response.dart';
import 'package:pomodak/models/api/shop/transaction_response.dart';
import 'package:pomodak/models/api/shop/transaction_record_model.dart';

class TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepository({
    required this.remoteDataSource,
  });

  Future<TransactionRecordModel> buyItem(int itemId, int count) async {
    try {
      TransactionResponse data = await remoteDataSource.buyItemApi(
        itemId,
        count,
      );
      return data.transactionRecord;
    } catch (e) {
      rethrow;
    }
  }

  Future<TransactionRecordModel> sellCharacter(
      String characterInventoryId, int count) async {
    try {
      TransactionResponse data =
          await remoteDataSource.sellCharacterApi(characterInventoryId, count);

      return data.transactionRecord;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> applyTimeToItemInventory(int seconds) async {
    try {
      return await remoteDataSource.applyTimeToItemInventoryApi(seconds);
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> consumeItem(String inventoryId) async {
    try {
      return await remoteDataSource.consumeItemApi(inventoryId);
    } catch (e) {
      rethrow;
    }
  }

  Future<RewardPointsResponse> rewardPoints(int points) async {
    try {
      RewardPointsResponse data =
          await remoteDataSource.rewardPointsApi(points);

      return data;
    } catch (e) {
      rethrow;
    }
  }
}
