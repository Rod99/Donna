import 'package:donna/pages/mobile/home_mobile.dart';
import 'package:donna/pages/mobile/welcome_mobile.dart';
import 'package:donna/utils/mobile/waves.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingMobile extends StatelessWidget {

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Bienvenido a Donna",
        body: "Donna te permitirá mejorar la calidad de tus imágenes usando inteligencia artificial y redes neuronales. Inténtalo y dale nueva vista a tus imágenes que creías dañadas",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset("assets/onboarding/slide1.png", height: 300.0),
          ),
        ),
      ),
      PageViewModel(
        title: "Selecciona una imagen",
        body: "Para comenzar, puedes elegir una o más imágenes a las que desees mejorar su calidad. Estas tienen que estar en los formatos: jpg o jpeg.",
        image: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Center(
            child: Image.asset("assets/onboarding/slide2.png", height: 300.0),
          ),
        ),
      ),
      PageViewModel(
        title: "Proceso de mejora",
        body: "Al subir la imagen, el algoritmo de inteligencia artificial identificará el objeto de la imagen y tratará de mejorar la resolución y calidad en función de este.",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset("assets/onboarding/slide3.png", height: 200.0),
          ),
        ),
      ),
      PageViewModel(
        title: "Resultados",
        body: "La imagen original será mejorada en función de lo que se detecte en ella y con ello, obtendrás una imagen con una calidad superior lista para guardarse. ¡Inténtalo!",
        image: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Image.asset("assets/onboarding/slide4.png", height: 250.0, width: 300,),
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomeMobile();
        } else if (snapshot.hasError){
          return const Center(child: Text('Ocurrió un error. Inicia sesión nuevamente.'));
        } else {
          return SafeArea(
            child: Scaffold(
              body: IntroductionScreen(
                globalFooter: const WavesMobile(),
                controlsPadding: EdgeInsets.only(
                  bottom: height * 0.71,
                  left: 8,
                  right: 8,
                ),
                pages: getPages(),
                showSkipButton: true,
                onDone: () {
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
                            alignment: Alignment.topRight,
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, animationTime) {
                          return WelcomeMobile();
                        },
                      ),
                  );
                },
                skip: const Text('Omitir'),
                next: const Icon(Icons.navigate_next),
                done: const Text("¡Estoy listo!", style: TextStyle(fontWeight: FontWeight.w600)),
                dotsDecorator: DotsDecorator(
                  size: const Size.square(10.0),
                  activeSize: const Size(20.0, 10.0),
                  activeColor: Colors.orange,
                  color: Colors.blue,
                  spacing: const EdgeInsets.symmetric(horizontal: 3.0),
                  activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
          );
        }
      }
    );
  }
}
