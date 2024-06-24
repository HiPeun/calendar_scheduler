import 'package:flutter/material.dart';

import '../const/color.dart';

class ScheduleCard extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final String content;
  final Color color;

  const ScheduleCard(
      {required this.color,
      required this.content,
      required this.startTime,
      required this.endTime,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: primaryColor,
          width: 1.0,
        ),
        //박스 테두리 둥글게 해줌
        borderRadius: BorderRadius.circular(
          8.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  /// 1 -> 01
                  /// 10 -> 10
                  "${startTime.hour.toString().padLeft(2, "0")}:00",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: primaryColor,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  "${endTime.hour.toString().padLeft(2,"0")}:00",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      fontSize: 10.0),
                ),
              ],
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Text(content),
            ),
            Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              width: 16.0,
              height: 16.0,
            )
          ]),
        ),
      ),
    );
  }
}
