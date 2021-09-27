import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeMobile extends StatelessWidget {
  const WelcomeMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 15,
              left: 15,
              child: Image.asset(
                "assets/splash.png",
                width: 50,
                height: 50,
              ),
            ),
            Positioned(
              top: 24,
              left: 70,
              child: Text(
                "Donna",
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              top: 75,
              child: Image.asset(
                "assets/onboarding/slide1.png",
                width: size.width,
              ),
            )
          ],
        )
      ),
    );
  }
}
