import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_schedule/component/ad_layout.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/model/favorite_school_model.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/schedule_repository.dart';

import '../model/schedule_model.dart';

class SearchClassScreen extends StatelessWidget {
  final SchoolSearchModel school;

  const SearchClassScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return MainLayoutScreen(
        title: school.SCHUL_NM,
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
  // 선택한 학교
  SchoolSearchModel? school;

  // ScheduleRepository
  ScheduleRepository scheduleRepository = ScheduleRepository();

  // 변수값
  String SEM = "";
  String GRADE = "";
  String CLASS_NM = "";
  bool isSearch = false;

  // 요일별 스케쥴
  Map<String, List<ScheduleModel>> schedules = {};

  @override
  void initState() {
    super.initState();
    school = widget.school;
  }

  Map<String, String> getWeekDates() {
    DateTime today = DateTime.now();
    int todayIndex = today.weekday;
    DateTime monday = today.subtract(Duration(days: todayIndex - 1));
    DateTime friday = monday.add(const Duration(days: 4));

    return {
      "TI_FROM_YMD": scheduleRepository.getFormat(monday),
      "TI_TO_YMD": scheduleRepository.getFormat(friday)
    };
  }

  Future<void> onSaveFavorite() async {
    if (school == null) {
      return;
    }

    final box = await Hive.openBox<FavoriteSchoolModel>("FAVORITES");

    box.add(
      FavoriteSchoolModel(
          ATPT_OFCDC_SC_CODE: school!.ATPT_OFCDC_SC_CODE,
          ATPT_OFCDC_SC_NM: school!.ATPT_OFCDC_SC_NM,
          SD_SCHUL_CODE: school!.SD_SCHUL_CODE,
          SEM: SEM,
          GRADE: GRADE,
          SCHUL_NM: school!.SCHUL_NM,
          CLASS_NM: CLASS_NM,
          type: FavoriteType.SCHEDULE),
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("즐겨 찾기에 추가되었습니다.")));
    }
  }

  Future<void> onFetch() async {
    try {
      // 서버 통신 하기전 초기화
      setState(() {
        schedules = {};
      });

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

      final weekDates = getWeekDates();

      final res = await scheduleRepository.onFetch(
        ATPT_OFCDC_SC_CODE: school!.ATPT_OFCDC_SC_CODE,
        SD_SCHUL_CODE: school!.SD_SCHUL_CODE,
        SEM: SEM,
        GRADE: GRADE,
        CLASS_NM: CLASS_NM,
        TI_FROM_YMD: weekDates["TI_FROM_YMD"]!,
        TI_TO_YMD: weekDates["TI_TO_YMD"]!,
        SCHUL_NM: school!.SCHUL_NM,
      );

      final schedulesData = scheduleRepository.getSchedulePerDay(res);
      setState(() {
        schedules = schedulesData;
        isSearch = true;
      });
    } on DioException catch (e) {
      if (context.mounted) {
        renderSnackBar(context, e.message ?? "인터넷 연결이 원할 하지 않습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                items: List.generate(2, (index) => (index + 1).toString()),
                onChanged: (value) {
                  setState(() {
                    SEM = value!;
                    isSearch = false;
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
                    ? List.generate(6, (index) => (index + 1).toString())
                    : List.generate(3, (index) => (index + 1).toString()),
                onChanged: (value) {
                  setState(() {
                    GRADE = value!;
                    isSearch = false;
                  });
                }),
            DropDownView(
                title: "반",
                value: CLASS_NM,
                items: List.generate(12, (index) => (index + 1).toString()),
                onChanged: (value) {
                  setState(() {
                    CLASS_NM = value!;
                    isSearch = false;
                  });
                }),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              isSearch
                  ? ElevatedButton(
                      onPressed: () {
                        onSaveFavorite();
                      },
                      child: const Text(
                        "즐겨 찾기 추가",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                      ))
                  : ElevatedButton(
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
        if (schedules.keys.isNotEmpty)
          SizedBox(
            height: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  schedules.keys.map((e) => renderScheduleTile(e)).toList(),
            ),
          ),
        const AdLayout()
      ],
    );
  }

  Widget renderScheduleTile(String day) {
    String dayKor = "";
    switch (day) {
      case "MONDAY":
        dayKor = "월";
      case "TUESDAY":
        dayKor = "화";
      case "WEDNESDAY":
        dayKor = "수";
      case "THURSDAY":
        dayKor = "목";
      case "FRIDAY":
        dayKor = "금";
    }

    return Column(
      children: [
        Container(
          height: 40.0,
          width: 70.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Center(child: Text(dayKor)),
        ),
        ...schedules[day]!
            .map(
              (e) => Container(
                height: 40.0,
                width: 70.0,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 0.5)),
                child: Center(child: Text(e.ITRT_CNTNT)),
              ),
            )
            .toList(),
      ],
    );
  }

  void renderSnackBar(BuildContext context, String message) {
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
        const SizedBox(
          height: 5.0,
        ),
        DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
          isExpanded: true,
          hint: hint ?? Text(title),
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  alignment: AlignmentDirectional.center,
                  child: Text(e),
                ),
              )
              .toList(),
          value: value.isEmpty ? null : value,
          onChanged: onChanged,
          buttonStyleData: ButtonStyleData(
            height: 50,
            width: 160,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.black26,
              ),
              color: whiteColor,
            ),
            elevation: 2,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
            ),
            iconSize: 14,
            iconEnabledColor: lightColor,
            iconDisabledColor: Colors.grey,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: whiteColor,
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all(6),
              thumbVisibility: MaterialStateProperty.all(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        )),
      ],
    );
  }
}
