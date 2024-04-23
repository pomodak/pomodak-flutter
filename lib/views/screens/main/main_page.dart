import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/main/home_screen/home_screen.dart';
import 'package:pomodak/views/screens/main/inventory_screen/inventory_screen.dart';
import 'package:pomodak/views/screens/main/more_screen/more_screen.dart';
import 'package:pomodak/views/screens/main/shop_screen/shop_screen.dart';
import 'package:pomodak/views/screens/main/user_screen/user_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController _pageController;
  late final List<Widget> _widgetOptions;
  int _selectedIndex = 0;

  void navigateToShop() {
    _onItemTapped(2);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _widgetOptions = [
      HomeScreen(onNavigateToShop: navigateToShop),
      const UserScreen(),
      const ShopScreen(),
      const InventoryScreen(),
      const MoreScreen(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomBarDefault(
        items: items,
        backgroundColor: Theme.of(context).colorScheme.background,
        color: Colors.black38,
        colorSelected: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        indexSelected: _selectedIndex,
      ),
    );
  }
}

const List<TabItem> items = [
  TabItem(
    icon: Icons.home_outlined,
    title: '홈',
  ),
  TabItem(
    icon: Icons.people_outline,
    title: '내정보',
  ),
  TabItem(
    icon: Icons.shopping_cart_outlined,
    title: '상점',
  ),
  TabItem(
    icon: Icons.backpack_outlined,
    title: '인벤토리',
  ),
  TabItem(
    icon: Icons.settings_outlined,
    title: '설정',
  ),
];
