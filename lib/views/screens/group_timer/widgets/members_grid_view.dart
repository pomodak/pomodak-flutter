import 'package:flutter/material.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/group_timer_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:pomodak/views/screens/group_timer/widgets/member_card.dart';
import 'package:provider/provider.dart';

class MembersGridView extends StatefulWidget {
  const MembersGridView({super.key});

  @override
  State<MembersGridView> createState() => _MembersGridViewState();
}

class _MembersGridViewState extends State<MembersGridView> {
  static const int gridCount = 9; // 최대 그리드 칸 수

  @override
  Widget build(BuildContext context) {
    DateTime curDateTime = DateTime.now();

    return Consumer2<GroupTimerViewModel, TimerViewModel>(
      builder: (context, groupTimerVM, timerStateVM, child) {
        if (groupTimerVM.members.isEmpty) {
          return const Center(child: Text("No members connected."));
        }
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: gridCount,
          itemBuilder: (context, index) {
            if (groupTimerVM.members.length <= index) {
              return GridTile(
                  child: Image.asset("assets/icons/empty-space.png"));
            }

            final member = groupTimerVM.members[index];
            final memberDurationSeconds = timerStateVM.elapsedSeconds +
                curDateTime.difference(member.joinedAtUTC).inSeconds;

            return GridTile(
              child: MemberCard(
                nickname: member.nickname,
                imageUrl: member.imageUrl,
                timeStr: FormatUtil.formatSeconds(memberDurationSeconds),
              ),
            );
          },
        );
      },
    );
  }
}
