import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String apiKey = dotenv.get("API_KEY") ?? "";

  final String apiMealUrl = dotenv.get("API_MEAL_URL") ?? "";

  final String apiSchoolSearchUrl = dotenv.get("API_SCHOOL_SEARCH_URL") ?? "";

  final String apiElementaryScheduleUrl =
      dotenv.get("API_ELEMENTARY_SCHOOL_SCHEDULE_URL") ?? "";

  final String apiMiddleSchoolScheduleUrl =
      dotenv.get("API_MIDDLE_SCHOOL_SCHEDULE_URL") ?? "";

  final String apiHighSchoolScheduleUrl =
      dotenv.get("API_HIGH_SCHOOL_SCHEDULE_URL") ?? "";

  // test key
  final String adMobIosAdUnitId = "ca-app-pub-3940256099942544/2934735716";

  // test key
  final String adMobAosAdUnitId = "ca-app-pub-3940256099942544/6300978111";
}

final config = Config();
