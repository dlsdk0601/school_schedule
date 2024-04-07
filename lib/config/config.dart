import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String apiKey = dotenv.get("API_KEY", fallback: "");

  final String apiMealUrl = dotenv.get("API_MEAL_URL", fallback: "");

  final String apiSchoolSearchUrl =
      dotenv.get("API_SCHOOL_SEARCH_URL", fallback: "");

  final String apiElementaryScheduleUrl =
      dotenv.get("API_ELEMENTARY_SCHOOL_SCHEDULE_URL", fallback: "");

  final String apiMiddleSchoolScheduleUrl =
      dotenv.get("API_MIDDLE_SCHOOL_SCHEDULE_URL", fallback: "");

  final String apiHighSchoolScheduleUrl =
      dotenv.get("API_HIGH_SCHOOL_SCHEDULE_URL", fallback: "");

  // test key
  final String adMobIosAdUnitId = dotenv.get(
    "AD_MOB_IOS_AD_UNIT_ID",
    fallback: "ca-app-pub-3940256099942544/2934735716",
  );

  // test key
  final String adMobAosAdUnitId = dotenv.get(
    "AD_MOB_AOS_AD_UNIT_ID",
    fallback: "ca-app-pub-3940256099942544/6300978111",
  );
}

final config = Config();
