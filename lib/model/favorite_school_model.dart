// 즐겨 찾기 타입
enum FavoriteType { SCHEDULE, MEAL }

// 즐겨찾기 Model
class FavoriteSchoolModel {
  final String ATPT_OFCDC_SC_CODE; // 시도교육청코드
  final String ATPT_OFCDC_SC_NM; // 시도교육청명
  final String SD_SCHUL_CODE; // 행정표준코드
  final String AY; // 학년도
  final String SEM; // 학기
  final String GRADE; // 학년
  final String TI_FROM_YMD; // 시간표시작일자
  final String TI_TO_YMD; // 시간표종료일자
  final String SCHUL_NM; // 학교명
  final String CLASS_NM;
  final FavoriteType type;

  FavoriteSchoolModel({
    required this.ATPT_OFCDC_SC_CODE,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.AY,
    required this.SEM,
    required this.GRADE,
    required this.TI_FROM_YMD,
    required this.TI_TO_YMD,
    required this.SCHUL_NM,
    required this.CLASS_NM,
    required this.type,
  });

  FavoriteSchoolModel.fromJson(
      {required Map<String, String> json, required this.type})
      : ATPT_OFCDC_SC_CODE = json["ATPT_OFCDC_SC_CODE"] ?? "",
        ATPT_OFCDC_SC_NM = json["ATPT_OFCDC_SC_NM"] ?? "",
        SD_SCHUL_CODE = json["SD_SCHUL_CODE"] ?? "",
        AY = json["AY"] ?? "",
        SEM = json["SEM"] ?? "",
        GRADE = json["GRADE"] ?? "",
        TI_FROM_YMD = json["TI_FROM_YMD"] ?? "",
        SCHUL_NM = json["SCHUL_NM"] ?? "",
        CLASS_NM = json["CLASS_NM"] ?? "",
        TI_TO_YMD = json["TI_TO_YMD"] ?? "";
}
