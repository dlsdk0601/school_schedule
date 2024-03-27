import 'package:hive/hive.dart';

import '../utils/data_utils.dart';

part 'school_model.g.dart';

@HiveType(typeId: 1)
enum AtptOfcdcScCode {
  @HiveField(0)
  B10, // 서울
  @HiveField(1)
  C10, // 부산
  @HiveField(2)
  D10, // 대구
  @HiveField(3)
  E10, // 인천
  @HiveField(4)
  F10, // 광주
  @HiveField(5)
  G10, // 대전
  @HiveField(6)
  H10, // 울산
  @HiveField(7)
  I10, // 세종
  @HiveField(8)
  J10, // 경기도
  @HiveField(9)
  K10, // 강원도
  @HiveField(10)
  M10, // 충북
  @HiveField(11)
  N10, // 충남
  @HiveField(12)
  P10, // 전북
  @HiveField(13)
  Q10, // 전남
  @HiveField(14)
  R10, // 경북
  @HiveField(15)
  S10, // 경남
  @HiveField(16)
  T10 // 제주
}

@HiveType(typeId: 2)
class SchoolModel {
  @HiveField(0)
  final AtptOfcdcScCode code; // 시도교육청코드
  @HiveField(1)
  final String ATPT_OFCDC_SC_NM; // 시도교육청명
  @HiveField(2)
  final String SD_SCHUL_CODE; // 행정표준코드
  @HiveField(3)
  final String SCHUL_NM; // 학교명
  @HiveField(4)
  final String DGHT_CRSE_SC_NM; // 주야과정명
  @HiveField(5)
  final String ORD_SC_NM; // 계열명
  @HiveField(6)
  final String LOAD_DTM; // 수정일자

  SchoolModel({
    required this.code,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.SCHUL_NM,
    required this.DGHT_CRSE_SC_NM,
    required this.ORD_SC_NM,
    required this.LOAD_DTM,
  });

  SchoolModel.fromJson({required Map<String, dynamic> json})
      : code =
            DataUtils.nameToCityCode(name: json["ATPT_OFCDC_SC_CODE"] ?? "B10"),
        ATPT_OFCDC_SC_NM = json["ATPT_OFCDC_SC_NM"] ?? "",
        SD_SCHUL_CODE = json["SD_SCHUL_CODE"] ?? "",
        SCHUL_NM = json["SCHUL_NM"] ?? "",
        DGHT_CRSE_SC_NM = json["DGHT_CRSE_SC_NM"] ?? "",
        ORD_SC_NM = json["ORD_SC_NM"] ?? "",
        LOAD_DTM = json["LOAD_DTM"] ?? "";
}
