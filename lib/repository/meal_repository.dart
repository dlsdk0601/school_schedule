import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:school_schedule/config/config.dart';

import '../model/meal_model.dart';
import '../utils/day_utils.dart';

typedef MealList = Map<Days, MealModel?>;

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
  (MealList, MealList) getSchedulePerDay(List<MealModel> list) {
    final weekDay = getWeekDates();
    DateTime startAt = DateTime.parse(weekDay["MLSV_FROM_YMD"]!);

    MealList mealLunchData = {
      Days.MONDAY: null,
      Days.TUESDAY: null,
      Days.WEDNESDAY: null,
      Days.THURSDAY: null,
      Days.FRIDAY: null,
    };

    MealList mealDinnerData = {
      Days.MONDAY: null,
      Days.TUESDAY: null,
      Days.WEDNESDAY: null,
      Days.THURSDAY: null,
      Days.FRIDAY: null,
    };

    for (MealModel value in list) {
      DateTime parsedDate = DateTime.parse(value.MLSV_YMD);
      if (parsedDate == startAt && value.MMEAL_SC_NM == "중식") {
        mealLunchData[Days.MONDAY] = value;
        continue;
      }

      if (parsedDate == startAt && value.MMEAL_SC_NM == "석식") {
        mealDinnerData[Days.MONDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 1)) &&
          value.MMEAL_SC_NM == "중식") {
        mealLunchData[Days.TUESDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 1)) &&
          value.MMEAL_SC_NM == "석식") {
        mealDinnerData[Days.TUESDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 2)) &&
          value.MMEAL_SC_NM == "중식") {
        mealLunchData[Days.WEDNESDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 2)) &&
          value.MMEAL_SC_NM == "석식") {
        mealDinnerData[Days.WEDNESDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 3)) &&
          value.MMEAL_SC_NM == "중식") {
        mealLunchData[Days.THURSDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 3)) &&
          value.MMEAL_SC_NM == "석식") {
        mealDinnerData[Days.THURSDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 4)) &&
          value.MMEAL_SC_NM == "중식") {
        mealLunchData[Days.FRIDAY] = value;
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 4)) &&
          value.MMEAL_SC_NM == "석식") {
        mealDinnerData[Days.FRIDAY] = value;
        continue;
      }
    }
    return (mealLunchData, mealDinnerData);
  }
}
