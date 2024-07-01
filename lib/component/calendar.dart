import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../const/color.dart';

class Calendar extends StatelessWidget {

  final DateTime focusedDay;
  final OnDaySelected onDaySelected;
  final bool Function(DateTime day) selectedDayPredicate;


  const Calendar({required this.selectedDayPredicate,required this.focusedDay,required this.onDaySelected,super.key});

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(color: Colors.grey[200]!, width: 1.0),
    );
    final defaultTextStyle =
    TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w700);
    return TableCalendar(
      locale: "ko_KR",
     focusedDay: DateTime(2024, 3, 1),
      firstDay: DateTime(1800),
      lastDay: DateTime(3000),
      headerStyle: HeaderStyle(
        //포맷버튼이 보인다.
          formatButtonVisible: false,
          //제목이 가운데 있다.
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          )),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: true,
        defaultDecoration: defaultBoxDecoration,
        weekendDecoration: defaultBoxDecoration,
        selectedDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(
            color: primaryColor,
            width: 1.0,
          ),
        ),
        todayDecoration: defaultBoxDecoration.copyWith(
          color: primaryColor,
        ),
        defaultTextStyle: defaultTextStyle,
        weekendTextStyle: defaultTextStyle,
        selectedTextStyle: defaultTextStyle.copyWith(
          color: primaryColor,
        ),
        outsideDecoration: defaultBoxDecoration.copyWith(
          border: Border.all(
            color: Colors.transparent,
          ),
        ),
      ),
      onDaySelected: onDaySelected,
      selectedDayPredicate: selectedDayPredicate,

    );
  }
}
