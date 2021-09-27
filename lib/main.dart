import 'package:donna/pages/desktop/home_sreen_desktop.dart';
import 'package:donna/pages/mobile/on_boarding_mobile.dart';
import 'package:donna/pages/tablet/on_boarding_tablet.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResponsiveLayout(
          mobileBody: OnBoardingMobile(),
          tabletBody: OnBoardingTablet(),
          desktopBody: HomeScreenDesktop()
      ),
    );
  }
}
