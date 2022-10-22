import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:login_screen/shared/styles/colors.dart';

ThemeData darkTheme = ThemeData(
    primarySwatch: defaultColor,
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
        titleSpacing: 20.0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: HexColor('333739'),
            statusBarIconBrightness: Brightness.light),
        color: HexColor('333739'),
        elevation: 0.0,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.white)),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: HexColor('333739'),
        elevation: 20.0),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: "Jannah"),
        subtitle1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.3,
            fontFamily: "Jannah")),
    fontFamily: "Jannah");

ThemeData lightTheme = ThemeData(
    primarySwatch: defaultColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
        titleSpacing: 20.0,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark),
        color: Colors.white,
        elevation: 0.0,
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        iconTheme: IconThemeData(color: Colors.black)),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: defaultColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 20.0),
    textTheme: const TextTheme(
        bodyText1: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: "Jannah"),
        subtitle1: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            height: 1.3,
            fontFamily: "Jannah")),
    fontFamily: "Jannah");
