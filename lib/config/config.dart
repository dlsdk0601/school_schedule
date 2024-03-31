import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String apiMealUrl = dotenv.get("API_MEAL_URL") ?? "";

  final String apiKey = dotenv.get("API_KEY") ?? "";

  final String apiSchoolSearchUrl = dotenv.get("API_SCHOOL_SEARCH_URL") ?? "";

  final String apiElementaryScheduleUrl =
      dotenv.get("API_ELEMENTARY_SCHOOL_SCHEDULE_URL") ?? "";

  final String apiMiddleSchoolScheduleUrl =
      dotenv.get("API_MIDDLE_SCHOOL_SCHEDULE_URL") ?? "";

  final String apiHighSchoolScheduleUrl =
      dotenv.get("API_HIGH_SCHOOL_SCHEDULE_URL") ?? "";
}

final config = Config();
