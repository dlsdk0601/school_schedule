enum Days {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURSDAY,
  FRIDAY,
}

String dayToKorean(Days days) {
  switch (days) {
    case Days.MONDAY:
      return "월요일";
    case Days.TUESDAY:
      return "화요일";
    case Days.WEDNESDAY:
      return "수요일";
    case Days.THURSDAY:
      return "목요일";
    case Days.FRIDAY:
      return "금요일";
  }
}
