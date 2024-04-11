class MealModel {
  final String ATPT_OFCDC_SC_CODE;
  final String ATPT_OFCDC_SC_NM;
  final String SD_SCHUL_CODE;
  final String SCHUL_NM;
  final String MMEAL_SC_CODE; //  식사코드
  final String MMEAL_SC_NM; //  식사명
  final String MLSV_YMD; //  급식일자
  final double MLSV_FGR; //  급식인원수
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
        MLSV_FGR = json["MLSV_FGR"] ?? 0,
        DDISH_NM = json["DDISH_NM"] ?? "",
        ORPLC_INFO = json["ORPLC_INFO"] ?? "",
        CAL_INFO = json["CAL_INFO"] ?? "",
        NTR_INFO = json["NTR_INFO"] ?? "",
        MLSV_FROM_YMD = json["MLSV_FROM_YMD"] ?? "",
        MLSV_TO_YMD = json["MLSV_TO_YMD"] ?? "",
        LOAD_DTM = json["LOAD_DTM"] ?? "";
}

// res 예시
// {
//   "row":[
//     {
//       "ATPT_OFCDC_SC_CODE":"T10",
//       "ATPT_OFCDC_SC_NM":"제주특별자치도교육청",
//       "SD_SCHUL_CODE":"9290083",
//       "SCHUL_NM":"제주영지학교",
//       "MMEAL_SC_CODE":"2",
//       "MMEAL_SC_NM":"중식",
//       "MLSV_YMD":"20210104",
//       "MLSV_FGR":67.00,
//       "DDISH_NM":"현미찹쌀밥(친환경/영)배추된장국(영)5.6.13.오이배생채(영)13.쇠불고기(계절/영)5.6.13.16.오징어파전(영)1.5.6.13.17.배추김치(영)9.13.",
//       "ORPLC_INFO":"쌀 : 국내산김치류 : 국내산고춧가루(김치류) : 국내산쇠고기(종류) : 국내산(한우)돼지고기 : 국내산닭고기 : 국내산오리고기 : 국내산쇠고기 식육가공품 : 국내산돼지고기 식육가공품 : 국내산닭고기 식육가공품 : 국내산오리고기 가공품 : 국내산낙지 : 국내산고등어 : 국내산갈치 : 국내산오징어 : 국내산꽃게 : 국내산참조기 : 국내산콩 : 국내산",
//       "CAL_INFO":"644.9 Kcal","NTR_INFO":"탄수화물(g) : 99.7단백질(g) : 34.7지방(g) : 12.1비타민A(R.E) : 217.0티아민(mg) : 0.3리보플라빈(mg) : 0.5비타민C(mg) : 17.6칼슘(mg) : 141.4철분(mg) : 4.5",
//       "MLSV_FROM_YMD":"20210104",
//       "MLSV_TO_YMD":"20210104",
//       "LOAD_DTM":"20210111040008"
//     }
//   ]
// }
