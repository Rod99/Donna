import 'package:donna/pages/mobile/edit_profile_mobile.dart';
import 'package:donna/utils/constants.dart';
import 'package:donna/utils/mobile/header_waves.dart';
import 'package:donna/utils/models/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slimy_card/slimy_card.dart';

class ProfileMobile extends StatefulWidget {
  UserModel user;

  ProfileMobile({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileMobileState createState() => _ProfileMobileState();
}

class _ProfileMobileState extends State<ProfileMobile> {

  UserModel currentUser = UserModel(); 

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
          top: 90,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(widget.user.imageUrl!),
          ),
        ),
        Positioned(
          top: 200,
          child: ElevatedButton(
            onPressed: () async {
              final newUser = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage(usuario: widget.user)),
              );
              if(newUser != null){
                setState(() {
                  widget.user = newUser as UserModel;
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: secondary,
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
              widget.user.name!,
              style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          top: 270,
          child: Text(
            widget.user.email!,
            style: GoogleFonts.ubuntu(
              fontSize: 18,
              color: Colors.blue,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          top: 300,
          child: SlimyCard(
            color: secondary,
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
                  color: secondary,
                ),
              ),
            ),
          ),
        )
    ],);
  }
}
