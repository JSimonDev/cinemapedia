import 'package:flutter/material.dart';

class AppTheme {

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color.fromARGB(255, 39, 154, 255),
    // brightness: Brightness.dark,
    // scaffoldBackgroundColor: Colors.black,
    // appBarTheme: const AppBarTheme(backgroundColor: Colors.black)
  );

}