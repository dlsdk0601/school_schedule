class SchoolSearchModel {
  final String ATPT_OFCDC_SC_CODE; // 시도교육청코드
  final String ATPT_OFCDC_SC_NM; // 시도교육청명
  final String SD_SCHUL_CODE; // 행정표준코드
  final String SCHUL_NM; // 학교명
  final String SCHUL_KND_SC_NM; // 주야과정명

  SchoolSearchModel({
    required this.ATPT_OFCDC_SC_CODE,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.SCHUL_NM,
    required this.SCHUL_KND_SC_NM,
  });

  SchoolSearchModel.fromJson({required Map<String, String> json})
      : ATPT_OFCDC_SC_CODE = json["ATPT_OFCDC_SC_CODE"] ?? "",
        ATPT_OFCDC_SC_NM = json["ATPT_OFCDC_SC_NM"] ?? "",
        SD_SCHUL_CODE = json["SD_SCHUL_CODE"] ?? "",
        SCHUL_NM = json["SCHUL_NM"] ?? "",
        SCHUL_KND_SC_NM = json["SCHUL_KND_SC_NM"] ?? "";
}
