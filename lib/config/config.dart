import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String apiMealUrl = dotenv.get("API_MEAL_URL") ?? "";

  final String apiKey = dotenv.get("API_KEY") ?? "";

  final String apiSchoolSearchUrl = dotenv.get("API_SCHOOL_SEARCH_URL") ?? "";

  final String apiMiddleSchoolScheduleUrl =
      dotenv.get("https://open.neis.go.kr/hub/misTimetable") ?? "";
}

final config = Config();
