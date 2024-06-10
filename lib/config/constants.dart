import 'package:flutter/material.dart';
import 'package:todolist/config/size_config.dart';

const kPrimaryColor = Color.fromARGB(255, 25, 29, 32);
const kTextColor = Color(0xFF535353);
const kButtonColor = Color.fromARGB(255, 59, 58, 58);
const kButtonLightColor = Color.fromARGB(255, 227, 224, 224);
const kLightTextColor = Color(0xFFACACAC);
const kDefaultTextSize = 15.0;
const kListCardColor = Color.fromARGB(255, 239, 231, 165);

const kSecondaryColor = Colors.white;
const kFeatcherIconBackColor = Color(0xFFACACAC);
const kDefaultPadding = 20.0;
const kDeleteColor = Colors.red;
const kPrimaryGradientColor = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color.fromARGB(255, 82, 191, 211), Color(0xFFFF008197)]);
const kAnimationDuration = Duration(milliseconds: 200);

TextStyle kGeneralTextStyle(double fontSize, {bool isBold = false}) =>
    TextStyle(
      color: kPrimaryColor,
      fontFamily: 'Calibri',
      fontSize: getProportionateScreenWidth(fontSize),
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

TextStyle kGeneralTextStyleDisable(double fontSize, {bool isBold = false}) =>
    TextStyle(
      color: Color.fromARGB(255, 117, 116, 116),
      fontFamily: 'Calibri',
      fontSize: getProportionateScreenWidth(fontSize),
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

TextStyle kGeneralTextStyleSecondary(double fontSize, {bool isBold = false}) =>
    TextStyle(
      color: kSecondaryColor,
      fontFamily: 'Calibri',
      fontSize: getProportionateScreenWidth(fontSize),
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

TextStyle kGeneralTextStyleDelete(double fontSize, {bool isBold = false}) =>
    TextStyle(
      color: kDeleteColor,
      fontFamily: 'Calibri',
      fontSize: getProportionateScreenWidth(fontSize),
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFF6CA8F1),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);
