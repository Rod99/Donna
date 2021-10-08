import 'package:donna/pages/mobile/home_mobile.dart';
import 'package:donna/pages/mobile/login_mobile.dart';
import 'package:donna/pages/mobile/sign_up_mobile.dart';
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
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return HomeMobile();
          } else if (snapshot.hasError) {
            return const Center(child: Text('Algo salió mal. Intenta iniciar sesión nuevamente.'));
          } else {
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
                                  return SignUpMobile();
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
                    top: size.height * 0.55,
                    child: Align(
                      child: Text(
                        "O mediante redes sociales",
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
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
                          primary: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          final provider = Provider.of<GoogleSignInProvider>(
                              context,
                              listen: false,
                          );
                          provider.googleLogin();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                        ),
                        label: const Text('Iniciar sesión con Google'),
                      ),
                    ),
                  )
                ],
              )
            );
          }
        },
      )
    );
  }
}
