import 'package:calendar_scheduler/component/calendar.dart';

import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/schedule_with_category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';


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
  // Map<DateTime, List<ScheduleTable>> schedules = {
  //   DateTime.utc(2024, 3, 8): [
  //     ScheduleTable(
  //         id: 1,
  //         startTime: 11,
  //         endTime: 12,
  //         content: "플러터 공부하기",
  //         date: DateTime.utc(2024, 3, 8),
  //         color: categoryColors[0],
  //         createdAt: DateTime.now().toUtc()),
  //     ScheduleTable(
  //         id: 2,
  //         startTime: 14,
  //         endTime: 116,
  //         content: "NestJs 공부하기",
  //         date: DateTime.utc(2024, 3, 8),
  //         color: categoryColors[3],
  //         createdAt: DateTime.now().toUtc()),
  //   ]
  // };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet<ScheduleTable>(
            context: context,
            builder: (_) {
              return ScheduleBottomSheet(
                selectedDay: selectedDay,
              );
            },
          );

        },
        backgroundColor: primaryColor,
        child: Icon(
          Icons.add_alarm_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Calendar(
              focusedDay: selectedDay,
              onDaySelected: onDaySelected,
              selectedDayPredicate: selectedDayPredicate,
            ),
            StreamBuilder(
              stream: GetIt.I<AppDatabase>().streamSchedules(
                selectedDay,
              ),
              builder: (context,snapshot) {
                return TodayBanner(
                  taskCount: !snapshot.hasData ? 0 : snapshot.data!.length,
                  selectedDay: selectedDay,
                );
              }
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                child: StreamBuilder<List<ScheduleWithCategory>>(
                    stream: GetIt.I<AppDatabase>().streamSchedules(
                      selectedDay,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      }
                      if (snapshot.data == null) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final schedules = snapshot.data!;


                      return ListView.separated(
                        itemCount: schedules.length,
                        itemBuilder: (BuildContext context, int index) {
                          ///선택된 날짜에 해당되는 일정 리스트로 저장
                          ///List<Schedule>
                          ///
                          ///
                          final scheduleWithCategory = schedules[index];
                          final schedule = scheduleWithCategory.schedule;
                          final category = scheduleWithCategory.category;

                          return Dismissible(
                            key: ObjectKey(schedule.id),
                            direction: DismissDirection.endToStart,
                            // confirmDismiss: (DismissDirection direction) async {
                            //   GetIt.I<AppDatabase>()
                            //       .removeSchedule(schedule.id);
                            //
                            //   return true;
                            // },
                            onDismissed: (DismissDirection direction){
                              GetIt.I<AppDatabase>().removeSchedule(schedule.id);
                            },
                            child: GestureDetector(
                              onTap: ()async{
                                await showModalBottomSheet<ScheduleTable>(context: context, builder: (_){
                                  return ScheduleBottomSheet(selectedDay: selectedDay,
                                  id: schedule.id,);
                                });

                              },
                              child: ScheduleCard(
                                  color: Color(
                                    int.parse(
                                      "FF${category.color}",
                                      radix: 16,
                                    ),
                                  ),
                                  content: schedule.content,
                                  startTime: schedule.startTime,
                                  endTime: schedule.endTime),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext contex, int index) {
                          return SizedBox(
                            height: 16.0,
                          );
                        },
                      );
                    }),
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
    return date.isAtSameMomentAs(selectedDay);
  }
}
