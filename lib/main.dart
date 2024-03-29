import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_schedule/model/school_model.dart';
import 'package:school_schedule/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // hive 초기화
  await Hive.initFlutter();

  // adapter 등록
  Hive.registerAdapter<AtptOfcdcScCode>(AtptOfcdcScCodeAdapter());
  Hive.registerAdapter<SchoolModel>(SchoolModelAdapter());

  // Box 열어주기
  // await Hive.openBox("school_schedule");
  //
  // for (AtptOfcdcScCode code in AtptOfcdcScCode.values) {
  //   await Hive.openBox<SchoolModel>(code.name);
  // }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "sunflower",
      ),
      home: HomeScreen(),
    ),
  );
}
