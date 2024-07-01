import 'package:flutter/material.dart';

import '../const/color.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  String? category;

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
                    onEndSaved: onEndTimeSaved,
                    onEndValidate: onEndTimeValidate,
                    onStartSaved: onStartTimeSaved,
                    onStartValiated: onStartTimeValidate,
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

  String? onStartTimeValidate(String? val) {}

  void onEndTimeSaved(String? val) {
    if (val == null) {
      return;
    }
    endTime = int.parse(val);
  }

  String? onEndTimeValidate(String? val) {}

  void onContentSaved(String? val) {
    if (val == null) {
      return;
    }
    content = val;
  }

  String? onContentValidate(String? val) {}

  void onSavePressed() {
      formKey.currentState!.save();
      
      print("-=-----");
      print(startTime);
      print(endTime);
      print(content);
      print(category);
  }
}

//시간 클래스

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final FormFieldValidator<String> onStartValiated;
  final FormFieldValidator<String> onEndValidate;

  final GlobalKey<FormState> formKey = GlobalKey();

  _Time(
      {required this.onEndSaved,
      required this.onEndValidate,
      required this.onStartSaved,
      required this.onStartValiated,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                label: " 시작 시간 ",
                onSaved: onStartSaved,
                validator: onStartValiated,
              ),
            )
          ],
        ),
        SizedBox(
          width: 16.0,
        ),
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
