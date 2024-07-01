import 'package:flutter/material.dart';

import '../const/color.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  const ScheduleBottomSheet({super.key});

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
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
            child: Column(
              children: [
                _Time(),
                SizedBox(height: 8.0),
                _Content(),
                SizedBox(height: 8.0),
                _Categories(
                    selectedColor: selectedColor,
                    onTap: (String color) {
                      setState(() {
                        selectedColor = color;
                      });
                    }),
                SizedBox(height: 8.0),
                _SaveButton()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//시간 클래스

class _Time extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

   _Time({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextField(
                    label: " 시작 시간 ",
                    onSaved: (String? val) {},
                    validator: (String? val) {
                      print("시작 시간 벨리데이트 ");
                      return "시작 시간 오류!";
                    }),
              ),
              SizedBox(
                width: 16.0,
              ),
              Expanded(
                child: CustomTextField(
                  label: "마감 시간 ",
                  onSaved: (String? val) {},
                  validator: (String? val) {
                    print("마감 시간 벨리데이트 ");
                    return "마감 시간 오류!";
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(onPressed: (){
            // formKey.currentState!.save();
            final validated = formKey.currentState!.validate();
            print("----validated----");
            print(validated);
          }, child: Text("save"))
        ],
      ),
    );
  }
}

//콘텐츠 클래스
class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        label: "내용",
        expand: true,
        onSaved: (String? val) {},
        validator: (String? val) {},
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
  const _SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: Text("저장"),
          ),
        ),
      ],
    );
  }
}
