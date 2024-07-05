import 'package:flutter/material.dart';
import 'package:expanse_tracker/widgets/expanses.dart';

//fromseed means set one color, and derived a colorScheme from it
//if we remove fromseed and used colorScheme() like this then we will have to setup
//the entire settings of it manually while fromseed works like copywith
var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);
var kDarkColorScheme = ColorScheme.fromSeed(
  //brightness.dark means this color scheme is for dark mode
  //bedefault its for lightmode
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);

void main() {
  runApp(MaterialApp(
    //.dark means a predefined setting for darfk theme
    darkTheme: ThemeData.dark().copyWith(
      colorScheme: kDarkColorScheme,
      cardTheme: const CardTheme().copyWith(
        color: kDarkColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kDarkColorScheme.primaryContainer,
          foregroundColor: kDarkColorScheme.onPrimaryContainer,
        ),
      ),
    ),
    //we are not defining entire theme in theme data instead we are using copywith
    //the reason is in thmedata we would should set up entire theme manually froms scratch
    //while copywith helps us changing certain theming and let the others default
    theme: ThemeData().copyWith(
      colorScheme: kColorScheme,
      appBarTheme: AppBarTheme(
        //we can use different shades of k color scheme
        backgroundColor: kColorScheme.onPrimaryContainer,
        foregroundColor: kColorScheme.primaryContainer,
      ),
      cardTheme: const CardTheme().copyWith(
        color: kColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kColorScheme.primaryContainer,
        ),
      ),
      textTheme: ThemeData().textTheme.copyWith(
            titleLarge: TextStyle(
              fontWeight: FontWeight.normal,
              color: kColorScheme.secondaryContainer,
              fontSize: 14,
            ),
          ),
    ),
    debugShowCheckedModeBanner: false,
    home: const Expanses(),
  ));
}
