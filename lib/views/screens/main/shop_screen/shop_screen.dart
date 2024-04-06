import 'package:flutter/material.dart';
import 'package:pomodak/models/domain/item_model.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/views/screens/main/shop_screen/widgets/shop_list_item.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopViewModel>(context, listen: false).loadShop();
    });
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('상점'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                child: Text(
                  "알",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  "아이템",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Consumer<ShopViewModel>(
          builder: (context, shopViewModel, child) {
            return TabBarView(
              children: <Widget>[
                ShopItemsList(items: shopViewModel.foodItems),
                ShopItemsList(items: shopViewModel.consumableItems),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ShopItemsList extends StatelessWidget {
  final List<ItemModel> items;

  const ShopItemsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: items
            .map(
              (item) => ShopListItem(
                item: item,
              ),
            )
            .toList(),
      ),
    );
  }
}
