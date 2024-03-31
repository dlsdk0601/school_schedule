class ScheduleModel {
  final String ATPT_OFCDC_SC_CODE;
  final String ATPT_OFCDC_SC_NM;
  final String SD_SCHUL_CODE;
  final String SCHUL_NM;
  final String AY;
  final String SEM;
  final String ALL_TI_YMD;
  final String DGHT_CRSE_SC_NM;
  final String GRADE;
  final String CLASS_NM;
  final String PERIO;
  final String ITRT_CNTNT;
  final String LOAD_DTM;

  ScheduleModel({
    required this.ATPT_OFCDC_SC_CODE,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.SCHUL_NM,
    required this.AY,
    required this.SEM,
    required this.ALL_TI_YMD,
    required this.DGHT_CRSE_SC_NM,
    required this.GRADE,
    required this.CLASS_NM,
    required this.PERIO,
    required this.ITRT_CNTNT,
    required this.LOAD_DTM,
  });

  ScheduleModel.fromJson({required Map<String, dynamic> json})
      : ATPT_OFCDC_SC_CODE = json["ATPT_OFCDC_SC_CODE"] ?? "",
        ATPT_OFCDC_SC_NM = json["ATPT_OFCDC_SC_NM"] ?? "",
        SD_SCHUL_CODE = json["SD_SCHUL_CODE"] ?? "",
        SCHUL_NM = json["SCHUL_NM"] ?? "",
        AY = json["AY"] ?? "",
        SEM = json["SEM"] ?? "",
        ALL_TI_YMD = json["ALL_TI_YMD"] ?? "",
        DGHT_CRSE_SC_NM = json["DGHT_CRSE_SC_NM"] ?? "",
        GRADE = json["GRADE"] ?? "",
        CLASS_NM = json["CLASS_NM"] ?? "",
        PERIO = json["PERIO"] ?? "",
        ITRT_CNTNT = json["ITRT_CNTNT"] ?? "",
        LOAD_DTM = json["LOAD_DTM"] ?? "";
}

// {
//   "row":
//     [
//       {
//        "ATPT_OFCDC_SC_CODE":"T10", 시도교육청코드
//        "ATPT_OFCDC_SC_NM":"제주특별자치도교육청",
//        "SD_SCHUL_CODE":"7003714", 행정표준코드
//        "SCHUL_NM":"제주대학교사범대학부설중학교",
//        "AY":"2023", 학년도
//        "SEM":"1", 학기
//        "ALL_TI_YMD":"20230306", 시간표일자
//        "DGHT_CRSE_SC_NM":"주간", 주야과정명
//        "GRADE":"1", 학년
//        "CLASS_NM":"1", 학급명
//        "PERIO":"1", 교시
//        "ITRT_CNTNT":"-수학", ITRT_CNTNT
//        "LOAD_DTM":"20230312" LOAD_DTM
//        },
//       {"ATPT_OFCDC_SC_CODE":"T10","ATPT_OFCDC_SC_NM":"제주특별자치도교육청","SD_SCHUL_CODE":"7003714","SCHUL_NM":"제주대학교사범대학부설중학교","AY":"2023","SEM":"1","ALL_TI_YMD":"20230306","DGHT_CRSE_SC_NM":"주간","GRADE":"1","CLASS_NM":"1","PERIO":"2","ITRT_CNTNT":"-영어","LOAD_DTM":"20230312"},
//       {"ATPT_OFCDC_SC_CODE":"T10","ATPT_OFCDC_SC_NM":"제주특별자치도교육청","SD_SCHUL_CODE":"7003714","SCHUL_NM":"제주대학교사범대학부설중학교","AY":"2023","SEM":"1","ALL_TI_YMD":"20230306","DGHT_CRSE_SC_NM":"주간","GRADE":"1","CLASS_NM":"1","PERIO":"3","ITRT_CNTNT":"-사회","LOAD_DTM":"20230312"},
//       {"ATPT_OFCDC_SC_CODE":"T10","ATPT_OFCDC_SC_NM":"제주특별자치도교육청","SD_SCHUL_CODE":"7003714","SCHUL_NM":"제주대학교사범대학부설중학교","AY":"2023","SEM":"1","ALL_TI_YMD":"20230306","DGHT_CRSE_SC_NM":"주간","GRADE":"1","CLASS_NM":"1","PERIO":"4","ITRT_CNTNT":"-과학","LOAD_DTM":"20230312"},
//       {"ATPT_OFCDC_SC_CODE":"T10","ATPT_OFCDC_SC_NM":"제주특별자치도교육청","SD_SCHUL_CODE":"7003714","SCHUL_NM":"제주대학교사범대학부설중학교","AY":"2023","SEM":"1","ALL_TI_YMD":"20230306","DGHT_CRSE_SC_NM":"주간","GRADE":"1","CLASS_NM":"1","PERIO":"5","ITRT_CNTNT":"-(자)주제선택활동","LOAD_DTM":"20230312"}
//     ]
// }
