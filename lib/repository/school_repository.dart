import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:school_schedule/model/school_model.dart';

import '../config/config.dart';

class SchoolSearchRepository {
  static Future<List<SchoolSearchModel>> onFetch(
      {required int page, required String search}) async {
    final res = await Dio().get(config.apiSchoolUrl, queryParameters: {
      "Key": config.apiKey,
      "Type": "json",
      "pIndex": page,
      "pSize": 20,
      "SCHUL_NM": search,
    });

    Map<String, dynamic> data = json.decode(res.toString());

    List<dynamic> rows = data["schoolInfo"][1]["row"];

    return rows
        .map<SchoolSearchModel>(
            (item) => SchoolSearchModel.fromJson(json: item))
        .toList();
  }
}
