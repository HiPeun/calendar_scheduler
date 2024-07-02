import 'package:calendar_scheduler/model/schedule.dart';
import 'package:flutter/material.dart';

import '../const/color.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDay;

  const ScheduleBottomSheet({required this.selectedDay, super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

  //selectedColor 내가 선택한 컬러는 카테고리 컬러에서 첫번째 컬러(레드)에서 선택한다
  //그걸 String 값으로 전달하도록 한다.

  String selectedColor = categoryColors.first;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Container(
        color: Colors.white,
        height: 1000,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  _Time(
                    onStartSaved: onStartTimeSaved,
                    onStartValidate: onStartTimeValidate,
                    onEndSaved: onEndTimeSaved,
                    onEndValidate: onEndTimeValidate,
                  ),
                  SizedBox(height: 8.0),
                  _Content(
                    onSaved: onContentSaved,
                    onValidate: onContentValidate,
                  ),
                  SizedBox(height: 8.0),
                  _Categories(
                      selectedColor: selectedColor,
                      onTap: (String color) {
                        setState(() {
                          selectedColor = color;
                        });
                      }),
                  SizedBox(height: 8.0),
                  _SaveButton(
                    onPressed: onSavePressed,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onStartTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    startTime = int.parse(val);
  }

  String? onStartTimeValidate(String? val) {
    if (val == null) {
      return "값을 입력해 주세요";
    }
    if (int.tryParse(val) == null) {
      return "숫자를 입력해주세요";
    }
    final time = int.parse(val);
    if (time > 24 || time < 0) {
      return "0과 24 사이의 숫자를 입력해 주세요";
    }
    return null;
  }

  void onEndTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val) {
    if (val == null) {
      return "값을 입력해 주세요";
    }
    if (int.tryParse(val) == null) {
      return "숫자를 입력해주세요";
    }
    final time = int.parse(val);
    if (time > 25 || time < 0) {
      return "0과 24 사이의 숫자를 입력해 주세요";
    }
    return null;
  }

  void onContentSaved(String? val) {
    if (val == null) {
      return;
    }
    content = val;
  }

  String? onContentValidate(String? val) {
    if (val == null) {
      return "내용을 입력해 주세요";
    }
    if (val.length < 5) {
      return "5자 이상을 입력해 주세요";
    }
    return null;
  }

  void onSavePressed() {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      // final schedule = ScheduleTable(
      //   id: 999,
      //   startTime: startTime!,
      //   endTime: endTime!,
      //   content: content!,
      //   color: selectedColor,
      //   date: widget.selectedDay,
      //   createdAt: DateTime.now().toUtc(),
      // );
      // Navigator.of(context).pop(
      //   schedule,
      // );
    }
  }
}

//시간 클래스

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;

  const _Time(
      {required this.onEndSaved,
      required this.onEndValidate,
      required this.onStartSaved,
      required this.onStartValidate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            label: " 시작 시간 ",
            onSaved: onStartSaved,
            validator: onStartValidate,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
            label: "마감 시간 ",
            onSaved: onEndSaved,
            validator: onEndValidate,
          ),
        ),
      ],
    );
  }
}

//콘텐츠 클래스
class _Content extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> onValidate;

  const _Content({required this.onSaved, required this.onValidate, super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: "내용",
        expand: true,
        onSaved: onSaved,
        validator: onValidate,
      ),
    );
  }
}

typedef OnCollorSelected = void Function(String color);

//카테고리 클래스
class _Categories extends StatelessWidget {
  final String selectedColor;
  final OnCollorSelected onTap;

  const _Categories(
      {required this.onTap, required this.selectedColor, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: categoryColors
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () {
                  onTap(e);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                      int.parse(
                        "FF$e",
                        radix: 16,
                      ),
                    ),
                    border: e == selectedColor
                        ? Border.all(
                            color: Colors.black,
                            width: 4.0,
                          )
                        : null,
                    shape: BoxShape.circle,
                  ),
                  width: 32.0,
                  height: 32.0,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: Text("저장"),
          ),
        ),
      ],
    );
  }
}
