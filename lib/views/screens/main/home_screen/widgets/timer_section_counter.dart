import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart'; // 스탬프 이미지 URL이 포함된 설정 파일
import 'package:pomodak/view_models/timer_options_view_model.dart';
import 'package:pomodak/view_models/timer_view_model/timer_view_model.dart';
import 'package:provider/provider.dart';

class TimerSectionCounter extends StatelessWidget {
  const TimerSectionCounter({super.key});

  @override
  Widget build(BuildContext context) {
    final sectionCompleted =
        context.select((TimerViewModel vm) => vm.sectionCounts);
    final sectionCount =
        context.select((TimerOptionsViewModel vm) => vm.sections);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sectionCount, (index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: index < sectionCompleted
              ? Image.network(CDNImages.mascot["finish"]!,
                  width: 24, height: 24) // 스탬프 이미지
              : const Icon(
                  Icons.lens_outlined,
                  size: 20,
                  color: Colors.black12,
                ),
        );
      }),
    );
  }
}
