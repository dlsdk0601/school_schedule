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
}
