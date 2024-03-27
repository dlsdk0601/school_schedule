import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  final String apiScheduleUrl = dotenv.get("API_SCHEDULE_URL") ?? "";

  final String apiSchoolUrl = dotenv.get("API_SCHOOL_URL") ?? "";

  final String apiMealUrl = dotenv.get("API_MEAL_URL") ?? "";

  final String apiKey = dotenv.get("API_KEY") ?? "";
}

final config = Config();
