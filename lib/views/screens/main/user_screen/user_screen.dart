import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/calendar/calendar.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/user_profile.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/user_focus_summary.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                leadingWidth: 120,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: Text(
                    "내정보",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                surfaceTintColor: Colors.white,
                pinned: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      UserProfile(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: UserFocusSummary(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: "🗓️ 캘린더"),
                      Tab(text: "🌿 잔디"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ListView(
                  shrinkWrap: true,
                  children: const [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Calendar(),
                      ],
                    ),
                  ],
                ),
              ),
              ListView(
                children: [
                  const Center(
                    child: Text(
                      "스트릭",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  HeatMap(
                    datasets: {
                      DateTime(2024, 3, 6): 2,
                      DateTime(2024, 3, 7): 4,
                      DateTime(2024, 3, 8): 5,
                      DateTime(2024, 3, 9): 7,
                      DateTime(2024, 3, 13): 6,
                    },
                    size: 32,
                    colorsets: {
                      1: Colors.green.shade100,
                      3: Colors.green.shade300,
                      5: Colors.green.shade500,
                      7: Colors.green.shade700,
                    },
                    onClick: (value) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(value.toString())));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
