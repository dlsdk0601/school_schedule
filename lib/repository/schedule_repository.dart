import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:school_schedule/config/config.dart';
import 'package:school_schedule/model/schedule_model.dart';

class ScheduleRepository {
  static Future<List<ScheduleModel>> onFetch({
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

    List<String> splites = url.split("/");
    // String key = splites[splites.length - 1];

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
}
