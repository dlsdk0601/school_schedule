class MealModel {
  final String ATPT_OFCDC_SC_CODE;
  final String ATPT_OFCDC_SC_NM;
  final String SD_SCHUL_CODE;
  final String SCHUL_NM;
  final String MMEAL_SC_CODE; //  식사코드
  final String MMEAL_SC_NM; //  식사명
  final String MLSV_YMD; //  급식일자
  final String MLSV_FGR; //  급식인원수
  final String DDISH_NM; //	 요리명
  final String ORPLC_INFO; //  원산지정보
  final String CAL_INFO; //  칼로리정보
  final String NTR_INFO; //  영양정보
  final String MLSV_FROM_YMD; //  급식시작일자
  final String MLSV_TO_YMD; //  급식종료일자
  final String LOAD_DTM; //  수정일자

  MealModel({
    required this.ATPT_OFCDC_SC_CODE,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.SCHUL_NM,
    required this.MMEAL_SC_CODE,
    required this.MMEAL_SC_NM,
    required this.MLSV_YMD,
    required this.MLSV_FGR,
    required this.DDISH_NM,
    required this.ORPLC_INFO,
    required this.CAL_INFO,
    required this.NTR_INFO,
    required this.MLSV_FROM_YMD,
    required this.MLSV_TO_YMD,
    required this.LOAD_DTM,
  });

  MealModel.fromJson({required Map<String, dynamic> json})
      : ATPT_OFCDC_SC_CODE = json["ATPT_OFCDC_SC_CODE"] ?? "",
        ATPT_OFCDC_SC_NM = json["ATPT_OFCDC_SC_NM"] ?? "",
        SD_SCHUL_CODE = json["SD_SCHUL_CODE"] ?? "",
        SCHUL_NM = json["SCHUL_NM"] ?? "",
        MMEAL_SC_CODE = json["MMEAL_SC_CODE"] ?? "",
        MMEAL_SC_NM = json["MMEAL_SC_NM"] ?? "",
        MLSV_YMD = json["MLSV_YMD"] ?? "",
        MLSV_FGR = json["MLSV_FGR"] ?? "",
        DDISH_NM = json["DDISH_NM"] ?? "",
        ORPLC_INFO = json["ORPLC_INFO"] ?? "",
        CAL_INFO = json["CAL_INFO"] ?? "",
        NTR_INFO = json["NTR_INFO"] ?? "",
        MLSV_FROM_YMD = json["MLSV_FROM_YMD"] ?? "",
        MLSV_TO_YMD = json["MLSV_TO_YMD"] ?? "",
        LOAD_DTM = json["LOAD_DTM"] ?? "";
}
