import 'package:flutter/material.dart';
import 'package:pomodak/config/constants/cdn_images.dart';
import 'package:pomodak/models/timer/alarm_info.dart';
import 'package:pomodak/utils/format_util.dart';

class _MessageData {
  final String imageUrl;
  final String message;

  _MessageData(this.imageUrl, this.message);
}

class AlarmImageAndMessage extends StatelessWidget {
  final AlarmInfo alarmInfo;
  const AlarmImageAndMessage({super.key, required this.alarmInfo});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final messageData = _getMessageData(alarmInfo);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: size.width / 2,
          child: Image.network(messageData.imageUrl),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            messageData.message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
            softWrap: true,
          ),
        ),
      ],
    );
  }

  _MessageData _getMessageData(AlarmInfo alarmInfo) {
    final String imageUrl;
    final String message;
    if (alarmInfo.alarmType == AlarmType.work) {
      imageUrl = CDNImages.mascot["exhausted"]!;
      message = "닭이 지쳤습니다. 잠시 휴식을 취해주세요!";
    } else if (alarmInfo.alarmType == AlarmType.rest) {
      imageUrl = CDNImages.mascot["wakeup"]!;
      message = "닭이 잠에서 깨어났습니다. 다시 집중해주세요!!";
    } else if (alarmInfo.alarmType == AlarmType.finish) {
      imageUrl = CDNImages.mascot["finish"]!;
      message = "한 섹션을 마무리했습니다. 충분한 휴식을 취해주세요!";
    } else if (alarmInfo.alarmType == AlarmType.giveup) {
      imageUrl = CDNImages.mascot["exhausted"]!;
      message = "닭이 포기했습니다 ㅜㅜ 다시 화이팅해서 도전해보세요!";
    } else {
      // normal & 그 외
      imageUrl = CDNImages.mascot["finish"]!;
      if (alarmInfo.time < 60) {
        message = "이야~~ ${alarmInfo.time}초나 집중하다니 정말 대단해!!";
      } else {
        message =
            "${FormatUtil.formatSeconds(alarmInfo.time)} 만큼 집중하셨습니다.\n 충분한 휴식을 취해주세요!";
      }
    }
    return _MessageData(imageUrl, message);
  }
}
