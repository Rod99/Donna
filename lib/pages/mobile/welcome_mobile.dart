import 'package:donna/pages/mobile/login_mobile.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WelcomeMobile extends StatelessWidget {
  const WelcomeMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasData){
            return SafeArea(
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
                  ),
                  Positioned(
                    top: 25,
                    right: 15,
                    child: TextButton.icon(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                        provider.signOut();
                      }, 
                      icon: const FaIcon(FontAwesomeIcons.powerOff, color: Colors.blue,), 
                      label: const Text('Salir', style: TextStyle(color: Colors.blueAccent),)
                    )
                  )
                ],
              )
            );
          } else if(snapshot.hasError) {
            return const Center(child: Text('Algo salió mal. Intenta iniciar sesión nuevamente.'));
          } else {
            return LoginMobile();
          }
        },
      )
    );
  }
}
