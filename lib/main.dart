import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pomodak/screens/home_screen.dart';
import 'package:pomodak/screens/inventory_screen.dart';
import 'package:pomodak/screens/more_screen.dart';
import 'package:pomodak/screens/shop_screen.dart';
import 'package:pomodak/screens/user_screen.dart';
import 'package:pomodak/theme/app_theme.dart';
import 'package:flutter/services.dart';

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

void main() async {
  await dotenv.load(fileName: ".env");
  // 세로모드 고정
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodak',
      theme: AppTheme.lightTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final PageController _pageController;
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const UserScreen(),
    const ShopScreen(),
    const InventoryScreen(),
    const MoreScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
