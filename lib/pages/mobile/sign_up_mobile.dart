import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpMobile extends StatelessWidget {
  const SignUpMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Hola, soy la pagina para registrarse',
          style: GoogleFonts.ubuntu(),
        ),
      ),
    );
  }
}
