import 'package:dio/dio.dart';
import 'package:school_schedule/model/schedule_model.dart';
import 'package:school_schedule/model/school_model.dart';

import '../config/config.dart';

class SchoolRepository {
  static Future<List<SchoolModel>> onFetch({
    required int page,
    required AtptOfcdcScCode code,
  }) async {
    final res = await Dio().get(config.apiSchoolUrl, queryParameters: {
      "Key": config.apiKey,
      "Type": "json",
      "pIndex": page,
      "pSize": 20,
      "ATPT_OFCDC_SC_CODE": code,
    });

    return res.data["response"]["body"][1]["row"]
        .map<SchoolModel>((item) => SchoolModel.fromJson(json: item))
        .toList();
  }
}

// {
//   "schulAflcoinfo": [
//     {"head":
//       [ {"list_total_count":56},
//         {"RESULT":
//           {"CODE":"INFO-000","MESSAGE":"정상 처리되었습니다."}
//         }
//       ]
//     },
//     {"row":
//       [
//         {
//           "ATPT_OFCDC_SC_CODE":"T10",
//           "ATPT_OFCDC_SC_NM":"제주특별자치도교육청",
//           "SD_SCHUL_CODE":"9290076",
//           "SCHUL_NM":"남녕고등학교",
//           "DGHT_CRSE_SC_NM":"주간",
//           "ORD_SC_NM":"일반계",
//           "LOAD_DTM":"20240301"
//         },
//         {
//           "ATPT_OFCDC_SC_CODE":"T10",
//           "ATPT_OFCDC_SC_NM":"제주특별자치도교육청",
//           "SD_SCHUL_CODE":"9290076",
//           "SCHUL_NM":"남녕고등학교",
//           "DGHT_CRSE_SC_NM":"주간",
//           "ORD_SC_NM":"체육계",
//           "LOAD_DTM":"20240301"
//         }
//       ]
//     }
//   ]
// }
