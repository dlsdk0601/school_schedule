import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_schedule/model/favorite_school_model.dart';
import 'package:school_schedule/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env init
  await dotenv.load(fileName: ".env");

  // 애드몹 init
  MobileAds.instance.initialize();

  // Hive init
  await Hive.initFlutter();

  // adapter 등록
  Hive.registerAdapter(FavoriteTypeAdapter());
  Hive.registerAdapter(FavoriteSchoolModelAdapter());

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "sunflower",
      ),
      home: HomeScreen(),
    ),
  );
}
