import 'package:pomodak/data/datasources/remote/shop_remote_datasource.dart';
import 'package:pomodak/models/api/shop/shop_item_response.dart';
import 'package:pomodak/models/domain/item_model.dart';

enum ItemType { food, consumable }

class ShopRepository {
  final ShopRemoteDataSource remoteDataSource;

  ShopRepository({
    required this.remoteDataSource,
  });

  Future<List<ItemModel>> fetchShopItems(ItemType itemType) async {
    try {
      ShopItemResponse data =
          await remoteDataSource.fetchShopItemsApi(itemType);
      return data.items;
    } catch (e) {
      rethrow;
    }
  }
}
