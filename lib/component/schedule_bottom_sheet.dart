import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../const/color.dart';
import '../database/drift.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final int? id;
  final DateTime selectedDay;

  const ScheduleBottomSheet({this.id, required this.selectedDay, super.key});

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

  int? selectedColorId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  initCategory() async {
    if (widget.id != null) {
      final resp = await GetIt.I<AppDatabase>().getScheduleById(widget.id!);
      setState(() {
        selectedColorId = resp.category.id;
      });
    } else {
      final resp = await GetIt.I<AppDatabase>().getCategories();

      setState(() {
        selectedColorId = resp.first.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (selectedColorId == null) {
      return Container();
    }
    return SafeArea(
      child: FutureBuilder(
          future: widget.id == null
              ? null
              : GetIt.I<AppDatabase>().getScheduleById(widget.id!),
          builder: (context, snapshot) {
            if (widget.id != null &&
                snapshot.connectionState == ConnectionState.waiting &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.data?.schedule;

            return Container(
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
                          startTimeInitValue: data?.startTime.toString(),
                          endTimeInitValue: data?.endTime.toString(),
                        ),
                        SizedBox(height: 8.0),
                        _Content(
                          onSaved: onContentSaved,
                          onValidate: onContentValidate,
                          initialValue: data?.content,
                        ),
                        SizedBox(height: 8.0),
                        _Categories(
                            selectedColor: selectedColorId!,
                            onTap: (int color) {
                              setState(() {
                                selectedColorId = color;
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
            );
          }),
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

  void onSavePressed() async {
    final isValid = formKey.currentState!.validate();

    if (isValid) {
      formKey.currentState!.save();

      final database = GetIt.I<AppDatabase>();

      if (widget.id == null) {
        await database.createSchedule(ScheduleTableCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          colorId: Value(selectedColorId!),
          date: Value(widget.selectedDay),
        ));
      } else {
        await database.updateScheduleById(
          widget.id!,
          ScheduleTableCompanion(
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
            date: Value(widget.selectedDay),
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }
}

//시간 클래스

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValidate;
  final FormFieldValidator<String> onEndValidate;
  final String? startTimeInitValue;
  final String? endTimeInitValue;

  const _Time(
      {required this.onEndSaved,
      required this.onEndValidate,
      required this.onStartSaved,
      required this.onStartValidate,
      this.endTimeInitValue,
      this.startTimeInitValue,
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
            initialValue: startTimeInitValue,
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: CustomTextField(
            label: "마감 시간 ",
            onSaved: onEndSaved,
            validator: onEndValidate,
            initialValue: endTimeInitValue,
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
  final String? initialValue;

  const _Content(
      {this.initialValue,
      required this.onSaved,
      required this.onValidate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: "내용",
        expand: true,
        onSaved: onSaved,
        validator: onValidate,
        initialValue: initialValue,
      ),
    );
  }
}

typedef OnColorSelected = void Function(int color);

//카테고리 클래스
class _Categories extends StatelessWidget {
  final int selectedColor;
  final OnColorSelected onTap;

  const _Categories(
      {required this.onTap, required this.selectedColor, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: GetIt.I<AppDatabase>().getCategories(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container();
          }
          return Row(
            children: snapshot.data!
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        onTap(e.id);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(
                              "FF${e.color}",
                              radix: 16,
                            ),
                          ),
                          border: e.id == selectedColor
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
        });
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
