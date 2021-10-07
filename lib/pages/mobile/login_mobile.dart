import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginMobile extends StatelessWidget {
  const LoginMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hola, soy el login',
          style: GoogleFonts.ubuntu(),
        ),
      ),
    );
  }
}