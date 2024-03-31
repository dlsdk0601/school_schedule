import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/ad_layout.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/schedule_repository.dart';

class SearchClassScreen extends StatelessWidget {
  final SchoolSearchModel school;

  const SearchClassScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return MainLayoutScreen(
        body: SearchClassView(
      school: school,
    ));
  }
}

class SearchClassView extends StatefulWidget {
  final SchoolSearchModel school;

  const SearchClassView({super.key, required this.school});

  @override
  State<SearchClassView> createState() => _SearchClassViewState();
}

class _SearchClassViewState extends State<SearchClassView> {
  // 상수값
  final List<String> semesters = ["1", "2"];
  final List<String> elementaryGrades = ["1", "2", "3", "4", "5", "6"];
  final List<String> grades = ["1", "2", "3"];
  final List<String> classes =
      List.generate(12, (index) => (index + 1).toString());

  // 선택한 학교
  SchoolSearchModel? school;

  // 변수값
  String SEM = "";
  String GRADE = "";
  String CLASS_NM = "";

  @override
  void initState() {
    super.initState();
    school = widget.school;
  }

  Future<Map<String, String>> getWeekDates() async {
    DateTime today = DateTime.now();
    int todayIndex = today.weekday;
    DateTime monday = today.subtract(Duration(days: todayIndex - 1));
    DateTime friday = monday.add(const Duration(days: 4));

    return {"TI_FROM_YMD": getFormat(monday), "TI_TO_YMD": getFormat(friday)};
  }

  String getFormat(DateTime dateTime) {
    return "${dateTime.year.toString().padLeft(4, "0")}${dateTime.month.toString().padLeft(2, "0")}${dateTime.day.toString().padLeft(2, "0")}";
  }

  Future<void> onFetch() async {
    try {
      // school 을 전 스크린에서 받아오기에 유효성 검사 한번 때린다.
      if (school == null) {
        renderSnackBar(context, "학교 정보가 원활하지 않습니다.");
        return;
      }

      if (SEM.isEmpty) {
        renderSnackBar(context, "학기를 선택해주세요.");
        return;
      }

      if (GRADE.isEmpty) {
        renderSnackBar(context, "학년을 선택해주세요.");
        return;
      }

      if (CLASS_NM.isEmpty) {
        renderSnackBar(context, "반을 선택해주세요.");
        return;
      }

      final weekDates = await getWeekDates();

      final res = await ScheduleRepository.onFetch(
        ATPT_OFCDC_SC_CODE: school!.ATPT_OFCDC_SC_CODE,
        SD_SCHUL_CODE: school!.SD_SCHUL_CODE,
        SEM: SEM,
        GRADE: GRADE,
        CLASS_NM: CLASS_NM,
        TI_FROM_YMD: weekDates["TI_FROM_YMD"]!,
        TI_TO_YMD: weekDates["TI_TO_YMD"]!,
        SCHUL_NM: school!.SCHUL_NM,
      );

      print("res");
      print(res);
    } on DioException catch (e) {
      renderSnackBar(context, "인터넷 연결이 원할 하지 않습니다.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropDownView(
                title: "학교",
                value: school!.SCHUL_NM,
                items: const [],
                onChanged: (value) {},
                hint: Text(
                  school!.SCHUL_NM,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w700),
                ),
              ),
              DropDownView(
                  title: "학기",
                  value: SEM,
                  items: semesters,
                  onChanged: (value) {
                    setState(() {
                      SEM = value!;
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropDownView(
                  title: "학년",
                  value: GRADE,
                  items: school!.SCHUL_NM.contains("초등학교")
                      ? elementaryGrades
                      : grades,
                  onChanged: (value) {
                    setState(() {
                      GRADE = value!;
                    });
                  }),
              DropDownView(
                  title: "반",
                  value: CLASS_NM,
                  items: classes,
                  onChanged: (value) {
                    setState(() {
                      CLASS_NM = value!;
                    });
                  }),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                    onPressed: () {
                      onFetch();
                    },
                    child: const Text(
                      "검색",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                      ),
                    )),
              ],
            ),
          ),
          Expanded(child: Container()),
          const AdLayout()
        ],
      ),
    );
  }

  void renderSnackBar(BuildContext context, String message) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class DropDownView extends StatelessWidget {
  final String title;
  final String value;
  final List<String> items;
  final Widget? hint;
  final ValueChanged<String?> onChanged;

  const DropDownView({
    super.key,
    required this.title,
    required this.items,
    required this.onChanged,
    required this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: DropdownButton<String>(
            hint: hint ?? Text(title),
            isExpanded: true,
            value: value.isEmpty ? null : value,
            items: items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    alignment: AlignmentDirectional.center,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
