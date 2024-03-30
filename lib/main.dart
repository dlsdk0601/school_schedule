import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:school_schedule/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: "sunflower",
      ),
      home: HomeScreen(),
    ),
  );
}
