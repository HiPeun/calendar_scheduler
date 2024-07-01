import 'package:flutter/material.dart';

import '../const/color.dart';


class TodayBanner extends StatelessWidget {

  final DateTime selectedDay;
  final int taskCount;

  const TodayBanner({required this.taskCount,required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${selectedDay.year}년${selectedDay.month}월 ${selectedDay.day}일",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "$taskCount개",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
