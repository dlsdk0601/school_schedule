import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:school_schedule/component/main_layout.dart';
import 'package:school_schedule/model/meal_model.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/repository/meal_repository.dart';

class SchoolMealScreen extends StatefulWidget {
  final SchoolSearchModel school;

  const SchoolMealScreen({super.key, required this.school});

  @override
  State<SchoolMealScreen> createState() => _SchoolMealScreenState();
}

class _SchoolMealScreenState extends State<SchoolMealScreen> {
  // mealRepository
  MealRepository mealRepository = MealRepository();

  // 요일별 스케쥴
  Map<String, List<MealModel>> schedules = {};

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
        schedules = mealSchedule;
      });
    } on DioException catch (e) {
      if (context.mounted) {
        renderSnackBar(context, e.message ?? "인터넷 연결이 원할 하지 않습니다.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (schedules.keys.isEmpty) {
      return const MainLayoutScreen(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return MainLayoutScreen(
      body: Column(
        children: schedules["MONDAY"]!
            .map((e) => Text(e.DDISH_NM.replaceAll("<br/>", '\n')))
            .toList(),
      ),
    );
  }

  void renderSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
