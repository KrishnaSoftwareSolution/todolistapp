import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/config/constants.dart';
import 'package:todolist/screens/splashscreen.dart';
import 'package:todolist/themes/themeprovider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: themeProvider.currentTheme,
      home: SplashScreen(),
    );
  }
}
