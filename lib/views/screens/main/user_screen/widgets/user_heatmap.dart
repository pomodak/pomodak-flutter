import 'package:flutter/material.dart';
import 'package:pomodak/utils/color_util.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/utils/message_util.dart';
import 'package:pomodak/view_models/member_view_model.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap_palette_tip.dart';
import 'package:provider/provider.dart';

class UserHeatMap extends StatelessWidget {
  const UserHeatMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerRecordViewModel = Provider.of<TimerRecordViewModel>(context);
    final memberViewModel = Provider.of<MemberViewModel>(context);
    final datasets = timerRecordViewModel.recordDatasets;

    var palette = memberViewModel.palette;

    return ListView(
      children: [
        const Center(
          child: Text(
            "스트릭",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        HeatMapPaletteTip(palette: palette),
        const SizedBox(height: 20),
        HeatMap(
          datasets: datasets,
          size: 32,
          colorsets: {
            1: palette != null
                ? Color(HexColor.fromHex(palette.lightColor)) // 0 ~ 2 시간
                : Colors.green.shade100,
            7200: palette != null
                ? Color(HexColor.fromHex(palette.normalColor)) // 2 ~ 4 시간
                : Colors.green.shade300,
            14400: palette != null
                ? Color(HexColor.fromHex(palette.darkColor)) // 4 ~ 6 시간
                : Colors.green.shade500,
            21600: palette != null
                ? Color(HexColor.fromHex(palette.darkerColor)) // 6 ~ 8 시간
                : Colors.green.shade700,
          },
          onClick: (value) {
            String dateStr = value.toString().split(" ")[0];
            String totalSeconds =
                FormatUtil.formatSeconds(datasets[value] ?? 0);

            MessageUtil.showSuccessToast(
                'Date: $dateStr\nFocus: $totalSeconds');
          },
        ),
      ],
    );
  }
}
