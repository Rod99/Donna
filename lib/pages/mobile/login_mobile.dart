import 'package:donna/utils/mobile/login_wave.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginMobile extends StatelessWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 30,
              left: 10,
              right: 10,
              child: Image.asset(
                "assets/login.png",
                width: size.width,
              ),
            ),
            WaveLogin()
          ],
        ),
      )
    );
  }
}