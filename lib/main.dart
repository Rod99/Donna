import 'package:donna/pages/desktop/home_sreen_desktop.dart';
import 'package:donna/pages/mobile/home_screen_mobile.dart';
import 'package:donna/pages/tablet/home_screen_tablet.dart';
import 'package:donna/utils/responsive_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donna',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveLayout(
          mobileBody: HomeScreenMobile(),
          tabletBody: HomeScreenTablet(),
          desktopBody: HomeScreenDesktop()
      ),
    );
  }
}