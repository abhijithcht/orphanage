import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.black,
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 26,
      color: Colors.black,
    ),
    iconTheme: IconThemeData(
      size: 30,
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  scaffoldBackgroundColor: Colors.white,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 0,
    foregroundColor: Colors.black,
    backgroundColor: Colors.blue,
    iconSize: 40,
  ),
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey[200],
    elevation: 0,
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: Colors.white,
    labelColor: Colors.white,
    unselectedLabelColor: Colors.black,
    splashFactory: NoSplash.splashFactory,
    overlayColor: WidgetStateProperty.all(Colors.transparent),
  ),
  cardTheme: CardThemeData(
    color: Colors.blue[100],
    clipBehavior: Clip.antiAlias,
    margin: const EdgeInsets.symmetric(vertical: 10),
  ),
  listTileTheme: const ListTileThemeData(
    visualDensity: VisualDensity.compact,
    horizontalTitleGap: 40,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      overflow: TextOverflow.ellipsis,
    ),
    subtitleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
      height: 2,
      overflow: TextOverflow.ellipsis,
    ),
    leadingAndTrailingTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
      overflow: TextOverflow.ellipsis,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    indicatorColor: Colors.blue,
    backgroundColor: Colors.grey[200],
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    bodyMedium: TextStyle(
      color: Colors.black54,
      fontSize: 14,
    ),
    labelLarge: TextStyle(
      color: Colors.white,
      fontSize: 16,
    ),
    bodySmall: TextStyle(
      color: Colors.black45,
      fontSize: 12,
    ),
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleMedium: TextStyle(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w500,
    ),
  ),
);
