import 'package:flutter/material.dart';
import 'package:pomodak/view_models/shop_view_model.dart';
import 'package:pomodak/views/screens/main/shop_screen/widgets/shop_list_item.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final shopViewModel = Provider.of<ShopViewModel>(context, listen: false);
    shopViewModel.loadShop();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('상점'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
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
        builder: (context, shop, child) {
          return TabBarView(
            controller: _tabController,
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (var item in shop.foodItems)
                      ShopListItem(
                        imageUrl: item.imageUrl,
                        name: item.name,
                        price: item.cost,
                        requiredTime: item.requiredStudyTime,
                      )
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    for (var item in shop.consumableItems)
                      ShopListItem(
                        imageUrl: item.imageUrl,
                        name: item.name,
                        price: item.cost,
                      )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
