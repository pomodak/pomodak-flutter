import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true, // Material 3 디자인을 사용
    textTheme: GoogleFonts.gamjaFlowerTextTheme(
      ThemeData.light().textTheme,
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black, // 앱 바, 버튼 등에 사용될 기본
      onPrimary: Colors.white, // primary 위의 텍스트
      secondary: Colors.black, // 추가적인 색상 (부차적인 버튼, 플로팅 액션 버튼 등)
      onSecondary: Colors.white, // secondary 위의 텍스트
      surface: Colors.white, // 카드뷰, 메뉴 배경
      onSurface: Colors.black, // surface 위의 텍스트나 아이콘
      background: Colors.white, // 스크린 배경
      onBackground: Colors.black, // 배경 위의 텍스트
      error: Colors.red, // 오류 메시지 등에 사용
      onError: Colors.white, // 오류 색상 위의 텍스트
    ),
    scaffoldBackgroundColor: Colors.white, // Scaffold의 배경색
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
  );
}
