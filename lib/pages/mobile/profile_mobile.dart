import 'package:donna/utils/mobile/header_waves.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';

class ProfileMobile extends StatelessWidget {
  const ProfileMobile(String? name, String? email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        HeaderWaves(),
        Positioned(
          top: 60,
          child: Text(
            'Perfil',
            style: GoogleFonts.ubuntu(
              fontSize: 24,
              color: Colors.white,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w100,
            ),),
      ),
        Positioned(
          top: 100,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
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
              "Rodrigo Vera",
              style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: 165,
          child: Text(
            'rodrigoveraescom@gmail.com',
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colors.white,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        Positioned(
          top: 300,
          child: SlimyCard(
            color: Colors.orange,
            width: size.width * 0.8,
            topCardHeight: 250,
            bottomCardHeight: 100,
            borderRadius: 15,
            topCardWidget:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '482',
                        style: GoogleFonts.ubuntu(
                            fontSize: 24,
                            color: Colors.white,
                        ),
                      ),
                      Text(
                        'imágenes totales',
                        style: GoogleFonts.ubuntu(
                            fontSize: 16,
                            color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  color: Colors.white,
                  thickness: 2,
                  indent: 50,
                  endIndent: 50,
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '5',
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'subidas hoy',
                        style: GoogleFonts.ubuntu(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '*Límite alcanzado*',
                        style: GoogleFonts.ubuntu(
                          fontSize: 9,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            bottomCardWidget: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.only(
                  left: 60,
                  top: 20,
                  right: 60,
                  bottom: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                "Premium",
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ),
        )
    ],);
  }
}
