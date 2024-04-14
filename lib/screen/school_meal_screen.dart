import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/meal_repository.dart';

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

  // 요일별 스케쥴
  MealList lunchSchedules = {};
  MealList dinnerSchedules = {};

  @override
  initState() {
    super.initState();
    onFetch();
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
      if (context.mounted) {
        renderSnackBar(context, e.message ?? "인터넷 연결이 원할 하지 않습니다.");
      }
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
      body: ListView(
        children: [
          Switch(
              value: isLunch,
              onChanged: (bool value) {
                setState(() {
                  isLunch = value;
                });
              }),
          ...Days.values.map((e) => renderTile(e)).toList(),
        ],
      ),
    );
  }

  void renderSnackBar(BuildContext context, String message) {
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
      style: const TextStyle(fontSize: 10.0),
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
      style: const TextStyle(fontSize: 10.0),
    );
  }

  Widget renderTile(Days days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Center(child: Text("${dayToKorean(days)} 중식")),
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
              renderLunchTile(days),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Column(
            children: [
              Center(child: Text("${dayToKorean(days)} 석식")),
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
              renderDinnerTile(days),
              const SizedBox(
                height: 20.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
