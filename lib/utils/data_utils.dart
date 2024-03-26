import '../model/school_model.dart';

class DataUtils {
  static String cityCodeToName({required AtptOfcdcScCode code}) {
    switch (code) {
      case AtptOfcdcScCode.B10:
        return "서울";
      case AtptOfcdcScCode.D10:
        return "대구";
      case AtptOfcdcScCode.N10:
        return "충남";
      case AtptOfcdcScCode.E10:
        return "인천";
      case AtptOfcdcScCode.G10:
        return "대전";
      case AtptOfcdcScCode.R10:
        return "경북";
      case AtptOfcdcScCode.I10:
        return "세종";
      case AtptOfcdcScCode.F10:
        return "광주";
      case AtptOfcdcScCode.P10:
        return "전북";
      case AtptOfcdcScCode.H10:
        return "울산";
      case AtptOfcdcScCode.Q10:
        return "전남";
      case AtptOfcdcScCode.C10:
        return "부산";
      case AtptOfcdcScCode.T10:
        return "제주";
      case AtptOfcdcScCode.M10:
        return "충북";
      case AtptOfcdcScCode.S10:
        return "경남";
      case AtptOfcdcScCode.J10:
        return "경기";
      case AtptOfcdcScCode.K10:
        return "강원";
    }
  }

  static AtptOfcdcScCode nameToCityCode({required String name}) {
    if (name == AtptOfcdcScCode.B10.name) {
      return AtptOfcdcScCode.B10;
    }
    if (name == AtptOfcdcScCode.D10.name) {
      return AtptOfcdcScCode.D10;
    }
    if (name == AtptOfcdcScCode.N10.name) {
      return AtptOfcdcScCode.N10;
    }
    if (name == AtptOfcdcScCode.E10.name) {
      return AtptOfcdcScCode.E10;
    }
    if (name == AtptOfcdcScCode.G10.name) {
      return AtptOfcdcScCode.G10;
    }
    if (name == AtptOfcdcScCode.R10.name) {
      return AtptOfcdcScCode.R10;
    }
    if (name == AtptOfcdcScCode.I10.name) {
      return AtptOfcdcScCode.I10;
    }
    if (name == AtptOfcdcScCode.F10.name) {
      return AtptOfcdcScCode.F10;
    }
    if (name == AtptOfcdcScCode.P10.name) {
      return AtptOfcdcScCode.P10;
    }
    if (name == AtptOfcdcScCode.H10.name) {
      return AtptOfcdcScCode.H10;
    }
    if (name == AtptOfcdcScCode.Q10.name) {
      return AtptOfcdcScCode.Q10;
    }
    if (name == AtptOfcdcScCode.C10.name) {
      return AtptOfcdcScCode.C10;
    }
    if (name == AtptOfcdcScCode.T10.name) {
      return AtptOfcdcScCode.T10;
    }
    if (name == AtptOfcdcScCode.M10.name) {
      return AtptOfcdcScCode.M10;
    }
    if (name == AtptOfcdcScCode.S10.name) {
      return AtptOfcdcScCode.S10;
    }
    if (name == AtptOfcdcScCode.J10.name) {
      return AtptOfcdcScCode.J10;
    }

    // name == ATPT_OFCDC_SC_CODE.K10.name
    return AtptOfcdcScCode.K10;
  }
}
