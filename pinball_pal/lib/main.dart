// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:pinball_pal/theme/theme.dart';
import './views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: PinballPalTheme.themeData(context),
      home: HomeView(),
    );
  }
}
