import 'package:flutter/material.dart';
import 'package:pomodak/widgets/calendar/default_cell_builder.dart';
import 'package:pomodak/widgets/calendar/dow_builder.dart';
import 'package:pomodak/widgets/calendar/header_title_builder.dart';
import 'package:pomodak/widgets/calendar/marked_cell_builder.dart';
import 'package:pomodak/widgets/calendar/outside_cell_builder.dart';
import 'package:pomodak/widgets/calendar/selected_cell_builder.dart';
import 'package:pomodak/widgets/calendar/today_cell_builder.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  var _selectedDay;
  var _calendarFormat = CalendarFormat.month;

  var _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      rowHeight: 64,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
      daysOfWeekHeight: 28,
      calendarBuilders: CalendarBuilders(
        outsideBuilder: (context, day, focusedDay) {
          return outsideCellBuilder(context, day, focusedDay);
        },
        defaultBuilder: (context, day, focusedDay) {
          return defaultCellBuilder(context, day, focusedDay);
        },
        headerTitleBuilder: (context, day) {
          return headerTitleBuilder(context, day);
        },
        selectedBuilder: (context, day, focusedDay) {
          return selectedCellBuilder(context, day, focusedDay);
        },
        todayBuilder: (context, day, focusedDay) {
          return todayCellBuilder(context, day, focusedDay);
        },
        markerBuilder: (context, day, events) {
          return markedCellBuilder(context, day, events);
        },
        dowBuilder: (context, day) {
          return dowBuilder(context, day);
        },
      ),
      eventLoader: (day) {
        if (14 < day.day && day.day < 23) {
          return ["test"];
        }
        return [];
      },
      firstDay: DateTime.utc(2023, 10, 16),
      lastDay: DateTime.now(),
      focusedDay: _focusedDay,
      availableGestures: AvailableGestures.none,
    );
  }
}
