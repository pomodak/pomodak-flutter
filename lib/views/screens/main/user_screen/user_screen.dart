import 'package:flutter/material.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/user_calendar.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/user_edit_modal.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/user_heatmap.dart';
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
                      fontSize: 18,
                    ),
                  ),
                ),
                surfaceTintColor: Colors.white,
                pinned: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      UserEditModal.show(context);
                    },
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
                        padding: EdgeInsets.symmetric(vertical: 28),
                        child: UserFocusSummary(),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    splashBorderRadius: BorderRadius.circular(10),
                    indicatorSize: TabBarIndicatorSize.label,
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: "🗓️ 캘린더",
                      ),
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
            children: const [
              UserCalendar(),
              UserHeatMap(),
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
