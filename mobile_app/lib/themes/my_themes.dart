import 'package:flutter/material.dart';

enum MyThemeKeys { CONSULTORIO_A, FARMACIA_A, FARMACIA_B, DEFAULT }

class MyThemes {
  static final ThemeData consultorioATheme = ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      fontFamily: 'Quicksand',
      textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18)),
      appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))));

  static final ThemeData farmaciaATheme = ThemeData(
      primaryColor: Colors.red[900],
      brightness: Brightness.light,
      fontFamily: 'Quicksand',
      textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18)),
      appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))));

  static final ThemeData farmaciaBTheme = ThemeData(
      primaryColor: Colors.deepOrange,
      brightness: Brightness.light,
      fontFamily: 'Quicksand',
      textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18)),
      appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))));

  static final ThemeData defaultTheme = ThemeData(
      primaryColor: Colors.grey,
      brightness: Brightness.light,
      fontFamily: 'Quicksand',
      textTheme: ThemeData.light().textTheme.copyWith(
          headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 18)),
      appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ))));

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.FARMACIA_A:
        return farmaciaATheme;
      case MyThemeKeys.FARMACIA_B:
        return farmaciaBTheme;
      case MyThemeKeys.CONSULTORIO_A:
        return consultorioATheme;
      default:
        return defaultTheme;
    }
  }
}
