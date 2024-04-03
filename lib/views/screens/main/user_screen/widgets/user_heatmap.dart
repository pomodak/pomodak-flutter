import 'package:flutter/material.dart';
import 'package:pomodak/utils/format_util.dart';
import 'package:pomodak/view_models/timer_record_view_model.dart';
import 'package:pomodak/views/screens/main/user_screen/widgets/heatmap/heatmap.dart';
import 'package:provider/provider.dart';

class UserHeatMap extends StatelessWidget {
  const UserHeatMap({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final timerRecordViewModel = Provider.of<TimerRecordViewModel>(context);
    final datasets = timerRecordViewModel.recordDatasets;
    return ListView(
      children: [
        const Center(
          child: Text(
            "스트릭",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),
        HeatMap(
          datasets: datasets,
          size: 32,
          colorsets: {
            1: Colors.green.shade100,
            3: Colors.green.shade300,
            5: Colors.green.shade500,
            7: Colors.green.shade700,
          },
          onClick: (value) {
            String dateStr = value.toString().split(" ")[0];
            String totalSeconds =
                FormatUtil.formatSeconds(datasets[value] ?? 0);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$dateStr - $totalSeconds')));
          },
        ),
      ],
    );
  }
}
