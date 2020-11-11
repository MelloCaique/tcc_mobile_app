import 'package:flutter/material.dart';
import 'package:mobile_app/screens/login.dart';
import 'package:mobile_app/themes/custom_theme.dart';
import 'package:mobile_app/themes/my_themes.dart';

void main() =>
    runApp(CustomTheme(initialThemeKey: MyThemeKeys.DEFAULT, child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Controle Receitas',
        theme: CustomTheme.of(context),
        home: Login());
  }
}
