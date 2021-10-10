import 'package:donna/pages/mobile/welcome_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({ Key? key }) : super(key: key);

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {

  final AuthenticationService _authService = getIt<AuthenticationService>();
  final GoogleSignInProvider _googleService = getIt<GoogleSignInProvider>();
  final StorageService _storageService = getIt<StorageService>();

  User? user = FirebaseAuth.instance.currentUser;
  UserModel currentUser = UserModel();

  @override
  void initState() {
    super.initState();
    _storageService.getUser(user!.uid).then(
      (user) {
        this.currentUser = user;
        setState(() {
          
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 0, 176, 255),
        unselectedItemColor: const Color.fromARGB(200, 0, 176, 255),
        showUnselectedLabels: true,
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
            Center(
              child: Text(
                "Bienvenido ${currentUser.name}",
                style: GoogleFonts.ubuntu(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: 25,
              right: 15,
              child: TextButton.icon(
                onPressed: () {
                  logOut(context);
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

  Future<void> logOut(BuildContext context) async {
    _googleService.signOut().then(
      (value) => {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomeMobile()
          )
        )
      });
  }
}