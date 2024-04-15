import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:hive/hive.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/constant/colors.dart';
import 'package:school_schedule/model/favorite_school_model.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/meal_repository.dart';
import 'package:school_schedule/utils/hive_utils.dart';

import '../constant/hive_constans.dart';
import '../utils/day_utils.dart';

class SchoolMealScreen extends StatefulWidget {
  final SchoolSearchModel school;

  const SchoolMealScreen({super.key, required this.school});

  @override
  State<SchoolMealScreen> createState() => _SchoolMealScreenState();
}

class _SchoolMealScreenState extends State<SchoolMealScreen> {
  // mealRepository
  MealRepository mealRepository = MealRepository();

  bool isLunch = true;
  bool hasFavorite = false;

  // 요일별 스케쥴
  MealList lunchSchedules = {};
  MealList dinnerSchedules = {};

  @override
  initState() {
    super.initState();
    onFetch();
    onBoxInit();
  }

  Future<void> onFetch() async {
    try {
      final weekDates = mealRepository.getWeekDates();

      final res = await mealRepository.onFetch(
        ATPT_OFCDC_SC_CODE: widget.school.ATPT_OFCDC_SC_CODE,
        SD_SCHUL_CODE: widget.school.SD_SCHUL_CODE,
        MLSV_FROM_YMD: weekDates["MLSV_FROM_YMD"]!,
        MLSV_TO_YMD: weekDates["MLSV_TO_YMD"]!,
      );

      final mealSchedule = mealRepository.getSchedulePerDay(res);
      setState(() {
        lunchSchedules = mealSchedule.$1;
        dinnerSchedules = mealSchedule.$2;
      });
    } on DioException catch (e) {
      renderSnackBar(e.message ?? "인터넷 연결이 원할 하지 않습니다.");
    }
  }

  Future<void> onBoxInit() async {
    final box = await Hive.openBox<FavoriteSchoolModel>(favoriteKey);

    setState(() {
      hasFavorite = box.values.any((element) =>
          element.SD_SCHUL_CODE == widget.school.SD_SCHUL_CODE &&
          element.SCHUL_NM == widget.school.SCHUL_NM);
    });
  }

  Future<void> onPressStarIcon() async {
    try {
      final box = await Hive.openBox<FavoriteSchoolModel>(favoriteKey);

      // 추가 된 애는 삭제
      if (hasFavorite) {
        final favoriteSchoolModel = box.values
            .where((element) =>
                element.SD_SCHUL_CODE == widget.school.SD_SCHUL_CODE &&
                element.SCHUL_NM == widget.school.SCHUL_NM)
            .first;

        await box.delete(getBoxKey(favoriteSchoolModel));

        setState(() {
          hasFavorite = false;
        });
        renderSnackBar("즐겨 찾기에 삭제되었습니다.");
        return;
      }

      // 없는애는 추가
      final favoriteSchoolModel = FavoriteSchoolModel(
        ATPT_OFCDC_SC_CODE: widget.school.ATPT_OFCDC_SC_CODE,
        ATPT_OFCDC_SC_NM: widget.school.ATPT_OFCDC_SC_NM,
        SD_SCHUL_CODE: widget.school.SD_SCHUL_CODE,
        SEM: widget.school.SCHUL_NM,
        GRADE: "",
        SCHUL_NM: widget.school.SCHUL_NM,
        CLASS_NM: "",
        type: FavoriteType.MEAL,
      );

      box.put(
        getBoxKey(favoriteSchoolModel),
        favoriteSchoolModel,
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
  Widget build(BuildContext context) {
    if (lunchSchedules.keys.isEmpty) {
      return const MainLayoutScreen(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MainLayoutScreen(
      title: "${widget.school.SCHUL_NM} 급식",
      actions: [
        IconButton(
          onPressed: onPressStarIcon,
          tooltip: "add favorite",
          icon: hasFavorite
              ? const Icon(Icons.star)
              : const Icon(Icons.star_border),
        ),
      ],
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlutterSwitch(
                  width: 65.0,
                  height: 30.0,
                  valueFontSize: 10.0,
                  borderRadius: 30.0,
                  value: isLunch,
                  activeText: "중식",
                  inactiveText: "석식",
                  activeColor: lightColor,
                  inactiveColor: lightColor,
                  inactiveTextColor: Colors.white,
                  showOnOff: true,
                  onToggle: (bool value) {
                    setState(() {
                      isLunch = value;
                    });
                  },
                  // activeColor: lightColor,
                ),
              ],
            ),
          ),
          ...Days.values.map((e) => renderTile(e)).toList(),
        ],
      ),
    );
  }

  void renderSnackBar(String message) {
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget renderLunchTile(Days days) {
    // 여기 올 일은 없지만 타입 안정성을 위해 유효성 걸어둔다.
    if (lunchSchedules[days] == null) {
      return Container();
    }

    return Text(
      lunchSchedules[days]!
          .DDISH_NM
          .replaceAll(RegExp(r'\s*\(.*?\)\s*'), "")
          .replaceAll("<br/>", '\n'),
      style: const TextStyle(fontSize: 15.0),
    );
  }

  Widget renderDinnerTile(Days days) {
    // 여기 올 일은 없지만 타입 안정성을 위해 유효성 걸어둔다.
    if (dinnerSchedules[days] == null) {
      return Container();
    }

    return Text(
      dinnerSchedules[days]!
          .DDISH_NM
          .replaceAll(RegExp(r'\s*\(.*?\)\s*'), "")
          .replaceAll("<br/>", '\n'),
      style: const TextStyle(fontSize: 15.0),
    );
  }

  Widget renderTile(Days days) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Center(
                  child: Text("${dayToKorean(days)} ${isLunch ? "중식" : "석식"}")),
              Container(
                height: 15.0,
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(width: 1.5),
                )),
              ),
              const SizedBox(
                height: 15.0,
              ),
              isLunch ? renderLunchTile(days) : renderDinnerTile(days),
              const SizedBox(
                height: 10.0,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20.0,
        )
      ],
    );
  }
}
