import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_schedule/component/ad_layout.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/favorite_school_model.dart';
import 'package:school_schedule/model/schedule_model.dart';
import 'package:school_schedule/repository/schedule_repository.dart';
import 'package:school_schedule/screen/home_screen.dart';
import 'package:school_schedule/utils/hive_utils.dart';

import '../constant/hive_constans.dart';

class SchoolScheduleScreen extends StatefulWidget {
  final FavoriteSchoolModel favoriteSchoolModel;

  const SchoolScheduleScreen({super.key, required this.favoriteSchoolModel});

  @override
  State<SchoolScheduleScreen> createState() => _SchoolScheduleScreenState();
}

class _SchoolScheduleScreenState extends State<SchoolScheduleScreen> {
  bool initialize = false;
  bool hasFavorite = false;

  // 요일별 스케쥴
  Map<String, List<ScheduleModel>> schedules = {};

  // Schedule repository
  ScheduleRepository scheduleRepository = ScheduleRepository();

  Future<void> onBoxInit() async {
    final box = await Hive.openBox<FavoriteSchoolModel>(favoriteKey);

    setState(() {
      hasFavorite = box.values.any((element) =>
          element.SD_SCHUL_CODE == widget.favoriteSchoolModel.SD_SCHUL_CODE &&
          element.SCHUL_NM == widget.favoriteSchoolModel.SCHUL_NM);
    });
  }

  Future<void> onFetch() async {
    try {
      final weekDates = scheduleRepository.getWeekDates();
      final res = await scheduleRepository.onFetch(
        ATPT_OFCDC_SC_CODE: widget.favoriteSchoolModel.ATPT_OFCDC_SC_CODE,
        SD_SCHUL_CODE: widget.favoriteSchoolModel.SD_SCHUL_CODE,
        SEM: widget.favoriteSchoolModel.SEM,
        GRADE: widget.favoriteSchoolModel.GRADE,
        CLASS_NM: widget.favoriteSchoolModel.CLASS_NM,
        TI_FROM_YMD: weekDates["TI_FROM_YMD"]!,
        TI_TO_YMD: weekDates["TI_TO_YMD"]!,
        SCHUL_NM: widget.favoriteSchoolModel.SCHUL_NM,
      );

      final schedulesData = scheduleRepository.getSchedulePerDay(res);
      setState(() {
        initialize = true;
        schedules = schedulesData;
      });
    } on DioException catch (e) {
      renderSnackBar(e.message ?? "인터넷 연결이 원활 하지 않습니다.");
    }
  }

  Future<void> onPressStarIcon() async {
    try {
      final box = await Hive.openBox<FavoriteSchoolModel>(favoriteKey);

      // 추가 된 애는 삭제
      if (hasFavorite) {
        await box.delete(getBoxKey(widget.favoriteSchoolModel));
        setState(() {
          hasFavorite = false;
        });
        renderSnackBar("즐겨 찾기에 삭제되었습니다.");
        return;
      }

      // 없는 애는 추가
      box.put(
        getBoxKey(widget.favoriteSchoolModel),
        widget.favoriteSchoolModel,
      );

      setState(() {
        hasFavorite = true;
      });
      renderSnackBar("즐겨 찾기에 추가되었습니다.");
    } on HiveError catch (e) {
      renderSnackBar(e.message);
    }
  }

  @override
  void initState() {
    super.initState();
    onFetch();
    onBoxInit();
  }

  @override
  Widget build(BuildContext context) {
    if (!initialize) {
      return const MainLayoutScreen(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MainLayoutScreen(
        title: widget.favoriteSchoolModel.SCHUL_NM,
        actions: [
          IconButton(
            onPressed: onPressStarIcon,
            tooltip: "add favorite",
            icon: hasFavorite
                ? const Icon(
                    Icons.star,
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.star_border,
                    color: Colors.white,
                  ),
          ),
        ],
        body: Column(
          children: [
            SizedBox(
              height: 470.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                      schedules.keys.map((e) => renderScheduleTile(e)).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const HomeScreen();
                            },
                          ),
                        );
                      },
                      child: const Text("학교 검색")),
                ],
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            const AdLayout()
          ],
        ));
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

  void renderSnackBar(String message) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
