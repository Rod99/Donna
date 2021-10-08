import 'package:donna/utils/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeMobile extends StatelessWidget {
  const HomeMobile({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 0, 176, 255),
        unselectedItemColor: const Color.fromARGB(200, 0, 176, 255),
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image_rounded),
            label: 'Mejora'
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: Text('Bienvenido al Home')),
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
            ),
            Positioned(
              top: 75,
              left: 20,
              right: 20,
              child: Image.asset(
                "assets/home.png",
                width: size.width,
              ),
            ),
          ],
        ),
      )
    );
  }
}