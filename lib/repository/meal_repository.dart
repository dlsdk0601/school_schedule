import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:school_schedule/config/config.dart';

import '../model/meal_model.dart';

class MealRepository {
  Future<List<MealModel>> onFetch({
    required String ATPT_OFCDC_SC_CODE,
    required String SD_SCHUL_CODE,
    required String MLSV_FROM_YMD,
    required String MLSV_TO_YMD,
  }) async {
    String url = config.apiMealUrl;

    final res = await Dio().get(url, queryParameters: {
      "Key": config.apiKey,
      "Type": "json",
      "pIndex": 1,
      "pSize": 100,
      "ATPT_OFCDC_SC_CODE": ATPT_OFCDC_SC_CODE,
      "SD_SCHUL_CODE": SD_SCHUL_CODE,
      "MLSV_FROM_YMD": MLSV_FROM_YMD,
      "MLSV_TO_YMD": MLSV_TO_YMD,
    });

    Map<String, dynamic> data = json.decode(res.toString());
    final String key = data.keys.first;

    if (data.containsKey("RESULT")) {
      final status = data[key]["CODE"];
      final message = data[key]["MESSAGE"];
      if (status != "INFO-000") {
        throw DioException(
            requestOptions: RequestOptions(path: url), message: message);
      }
    }

    List<dynamic> rows = data[key][1]["row"];

    return rows.map<MealModel>((e) => MealModel.fromJson(json: e)).toList();
  }

  // yyyyMMdd 데이터 포맷
  String getFormat(DateTime dateTime) {
    return "${dateTime.year.toString().padLeft(4, "0")}${dateTime.month.toString().padLeft(2, "0")}${dateTime.day.toString().padLeft(2, "0")}";
  }

  // 이번주 월 ~ 금 까지의 시간 계산
  Map<String, String> getWeekDates() {
    DateTime today = DateTime.now();
    int todayIndex = today.weekday;
    DateTime monday = today.subtract(Duration(days: todayIndex - 1));
    DateTime friday = monday.add(const Duration(days: 4));

    return {
      "MLSV_FROM_YMD": getFormat(monday),
      "MLSV_TO_YMD": getFormat(friday)
    };
  }

  // list 에서 월 ~ 금 시간표 분류 모듈
  Map<String, List<MealModel>> getSchedulePerDay(List<MealModel> list) {
    final weekDay = getWeekDates();
    DateTime startAt = DateTime.parse(weekDay["MLSV_FROM_YMD"]!);

    Map<String, List<MealModel>> mealScheduleData = {
      "MONDAY": [],
      "TUESDAY": [],
      "WEDNESDAY": [],
      "THURSDAY": [],
      "FRIDAY": []
    };

    for (MealModel value in list) {
      DateTime parsedDate = DateTime.parse(value.MLSV_YMD);
      if (parsedDate == startAt) {
        mealScheduleData["MONDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 1))) {
        mealScheduleData["TUESDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 2))) {
        mealScheduleData["WEDNESDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 3))) {
        mealScheduleData["THURSDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 4))) {
        mealScheduleData["FRIDAY"]!.add(value);
        continue;
      }
    }
    return mealScheduleData;
  }
}
