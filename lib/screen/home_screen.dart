import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

import '../component/schedule_card.dart';
import '../model/schedule.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  /// {
  ///    2023-11-23:[Schedule, Schedule],
  ///    2023-11-24:[Schedule, Schedule]
  /// }
  Map<DateTime, List<Schedule>> schedules = {
    DateTime.utc(2024, 3, 8): [
      Schedule(
          id: 1,
          startTime: 11,
          endTime: 12,
          content: "플러터 공부하기",
          date: DateTime.utc(2024, 3, 8),
          color: categoryColors[0],
          createdAt: DateTime.now().toUtc()),
      Schedule(
          id: 2,
          startTime: 14,
          endTime: 116,
          content: "NestJs 공부하기",
          date: DateTime.utc(2024, 3, 8),
          color: categoryColors[3],
          createdAt: DateTime.now().toUtc()),
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) {
              return ScheduleBottomSheet();
            },
          );
        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: DateTime(2024, 3, 1),
              onDaySelected: onDaySelected,
              selectedDayPredicate: selectedDayPredicate,
            ),
            TodayBanner(
              taskCount: 0,
              selectedDay: selectedDay,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: ListView.separated(
                  itemCount: schedules.containsKey(selectedDay)
                      ? schedules[selectedDay]!.length
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    ///선택된 날짜에 해당되는 일정 리스트로 저장
                    ///List<Schedule>
                    final selectedSchedules = schedules[selectedDay]!;
                    final scheduleModel = selectedSchedules[index];

                    return ScheduleCard(
                        color: Color(
                          int.parse(
                            "FF${scheduleModel.color}",
                            radix: 16,
                          ),
                        ),
                        content: scheduleModel.content,
                        startTime: scheduleModel.startTime,
                        endTime: scheduleModel.endTime);
                  },
                  separatorBuilder: (BuildContext contex, int index){
                    return SizedBox(height: 16.0,);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }

  bool selectedDayPredicate(DateTime date) {
    if (selectedDay == null) {
      return false;
    }
    return date.isAtSameMomentAs(selectedDay!);
  }
}