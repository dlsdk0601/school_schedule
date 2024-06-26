import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:school_schedule/config/config.dart';
import 'package:school_schedule/model/schedule_model.dart';

class ScheduleRepository {
  Future<List<ScheduleModel>> onFetch({
    required String ATPT_OFCDC_SC_CODE,
    required String SD_SCHUL_CODE,
    required String SEM,
    required String GRADE,
    required String CLASS_NM,
    required String TI_FROM_YMD,
    required String TI_TO_YMD,
    required String SCHUL_NM,
  }) async {
    // Default 는 초등학교
    String url = config.apiElementaryScheduleUrl;

    if (SCHUL_NM.contains("중학교")) {
      url = config.apiMiddleSchoolScheduleUrl;
    }

    if (SCHUL_NM.contains("고등학교")) {
      url = config.apiHighSchoolScheduleUrl;
    }

    final res = await Dio().get(url, queryParameters: {
      "Key": config.apiKey,
      "Type": "json",
      "pIndex": 1,
      "pSize": 100,
      "ATPT_OFCDC_SC_CODE": ATPT_OFCDC_SC_CODE,
      "SD_SCHUL_CODE": SD_SCHUL_CODE,
      "AY": DateTime.now().year.toString(), // 올해만 조회한다
      "SEM": SEM,
      "GRADE": GRADE,
      "CLASS_NM": CLASS_NM,
      "TI_FROM_YMD": TI_FROM_YMD,
      "TI_TO_YMD": TI_TO_YMD,
    });

    Map<String, dynamic> data = json.decode(res.toString());
    final String key = data.keys.first;

    // 실패 예시 {"RESULT":{"CODE":"INFO-200","MESSAGE":"해당하는 데이터가 없습니다."}}
    // 성공 예시 {"hisTimetable":[{"head":[{"list_total_count":32},{"RESULT":{"CODE":"INFO-000","MESSAGE":"정상 처리되었습니다."}}]},{"row":[
    if (data.containsKey("RESULT")) {
      final status = data[key]["CODE"];
      final message = data[key]["MESSAGE"];
      if (status != "INFO-000") {
        throw DioException(
            requestOptions: RequestOptions(path: url), message: message);
      }
    }

    List<dynamic> rows = data[key][1]["row"];

    return rows
        .map<ScheduleModel>((e) => ScheduleModel.fromJson(json: e))
        .toList();
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

    return {"TI_FROM_YMD": getFormat(monday), "TI_TO_YMD": getFormat(friday)};
  }

  // list 에서 월 ~ 금 시간표 분류 모듈
  Map<String, List<ScheduleModel>> getSchedulePerDay(List<ScheduleModel> list) {
    final weekDay = getWeekDates();
    DateTime startAt = DateTime.parse(weekDay["TI_FROM_YMD"]!);

    Map<String, List<ScheduleModel>> schedulesData = {
      "MONDAY": [],
      "TUESDAY": [],
      "WEDNESDAY": [],
      "THURSDAY": [],
      "FRIDAY": []
    };

    for (ScheduleModel value in list) {
      DateTime parsedDate = DateTime.parse(value.ALL_TI_YMD);
      if (parsedDate == startAt) {
        schedulesData["MONDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 1))) {
        schedulesData["TUESDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 2))) {
        schedulesData["WEDNESDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 3))) {
        schedulesData["THURSDAY"]!.add(value);
        continue;
      }

      if (parsedDate == startAt.add(const Duration(days: 4))) {
        schedulesData["FRIDAY"]!.add(value);
        continue;
      }
    }

    return schedulesData;
  }
}
