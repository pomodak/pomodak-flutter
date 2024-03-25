import 'package:flutter/material.dart';
import 'package:pomodak/widgets/user_focus_summary.dart';
import 'package:pomodak/widgets/user_profile.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              // 내정보 수정 모달 오픈
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: <Widget>[
              UserProfile(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: UserFocusSummary(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
