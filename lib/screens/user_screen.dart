import 'package:flutter/material.dart';
import 'package:pomodak/widgets/user_profile.dart';
import 'package:pomodak/widgets/user_focus_summary.dart';

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
        child: CustomScrollView(
          slivers: [
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
            SliverFillRemaining(
              hasScrollBody: true,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  Column(
                    children: [
                      SizedBox(height: 200),
                      Text("캘린더 탭 내용"),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(height: 200),
                      Text("캘린더 탭 내용"),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
