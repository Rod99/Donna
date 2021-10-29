import 'package:donna/pages/mobile/home_mobile.dart';
import 'package:donna/pages/mobile/login_mobile.dart';
import 'package:donna/pages/mobile/sign_up_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class WelcomeMobile extends StatefulWidget {

  @override
  _WelcomeMobileState createState() => _WelcomeMobileState();
}

class _WelcomeMobileState extends State<WelcomeMobile> {
  final GoogleSignInProvider _googleService = getIt<GoogleSignInProvider>();

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
                "assets/donna.png",
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
            Positioned.fill(
              top: size.height * 0.05,
              child: Align(
                child: Text(
                  "¡Bienvenido!",
                  style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: size.height * 0.15,
              child: Align(
                child: Text(
                  "¡Estás a un solo paso de mejorar tus imágenes!",
                  style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xff898A8D),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: size.height * 0.30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 2),
                          transitionsBuilder: (context, animation, animationTime, child) {
                            animation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.elasticOut,
                            );
                            return ScaleTransition(
                              alignment: Alignment.bottomCenter,
                              scale: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, animationTime) {
                            return const SignUpMobile();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 20,
                        right: 35,
                        bottom: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                        "Registrarme",
                      style: GoogleFonts.ubuntu(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 2),
                          transitionsBuilder: (context, animation, animationTime, child) {
                            animation = CurvedAnimation(
                              parent: animation,
                              curve: Curves.elasticOut,
                            );
                            return ScaleTransition(
                              alignment: Alignment.bottomCenter,
                              scale: animation,
                              child: child,
                            );
                          },
                          pageBuilder: (context, animation, animationTime) {
                            return const LoginMobile();
                          },
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        left: 35,
                        top: 20,
                        right: 35,
                        bottom: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text(
                      "Iniciar sesión",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
            Positioned.fill(
              top: size.height * 0.52,
              child: Align(
                child: Text(
                  "O mediante redes sociales",
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              top: size.height * 0.65,
              child: Align(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 15,
                      right: 20,
                      bottom: 15,
                    ),
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () async {
                    await _googleService.googleLogin().then(
                      (value) => {
                        if(value != null){
                          Navigator.pushAndRemoveUntil( 
                            (context), 
                            MaterialPageRoute(builder: (context) => const HomeMobile()),
                            (route) => false
                          )
                        }
                      }
                    );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.white,
                  ),
                  label: const Text('Iniciar sesión con Google', style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        )
      )
    );
  }

  Future googleSignIn() async {
    try {
      await _googleService.googleLogin()
        .then((value) => {
          Navigator.pushAndRemoveUntil( 
            (context), 
            MaterialPageRoute(builder: (context) => const HomeMobile()),
            (route) => false
          )
        });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
