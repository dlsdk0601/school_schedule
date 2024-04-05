// 즐겨 찾기 타입

import 'package:hive/hive.dart';

part "favorite_school_model.g.dart";

@HiveType(typeId: 1)
enum FavoriteType {
  @HiveField(0)
  SCHEDULE,
  @HiveField(1)
  MEAL
}

// 즐겨찾기 Model
@HiveType(typeId: 2)
class FavoriteSchoolModel {
  @HiveField(0)
  final String ATPT_OFCDC_SC_CODE; // 시도교육청코드
  @HiveField(1)
  final String ATPT_OFCDC_SC_NM; // 시도교육청명
  @HiveField(2)
  final String SD_SCHUL_CODE; // 행정표준코드
  @HiveField(3)
  final String SEM; // 학기
  @HiveField(4)
  final String GRADE; // 학년
  @HiveField(5)
  final String SCHUL_NM; // 학교명
  @HiveField(6)
  final String CLASS_NM; // 반
  @HiveField(7)
  final FavoriteType type;

  FavoriteSchoolModel({
    required this.ATPT_OFCDC_SC_CODE,
    required this.ATPT_OFCDC_SC_NM,
    required this.SD_SCHUL_CODE,
    required this.SEM,
    required this.GRADE,
    required this.SCHUL_NM,
    required this.CLASS_NM,
    required this.type,
  });
}
