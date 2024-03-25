import 'package:flutter/material.dart';
import 'package:pomodak/constants/cdn_images.dart';

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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < 10; ++i)
                  ShopListItem(
                    imageUrl: CDNImages.mascot["normal"]!,
                    name: "무료알$i",
                    price: 400,
                    requiredTime: 1200,
                  )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                for (var i = 0; i < 10; ++i)
                  ShopListItem(
                    imageUrl: CDNImages.mascot["exhausted"]!,
                    name: "아이템$i",
                    price: 400,
                    requiredTime: 7200,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShopListItem extends StatelessWidget {
  final String imageUrl, name;
  final num price;
  final num? requiredTime;

  const ShopListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.requiredTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Image.network(
              imageUrl,
              width: 100,
              height: 100,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$price원",
                  ),
                  if (requiredTime != null)
                    Text("⌛️ ${(requiredTime! / 60).floor()}분")
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
