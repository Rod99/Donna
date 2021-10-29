import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:donna/pages/mobile/profile_mobile.dart';
import 'package:donna/pages/mobile/welcome_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flimer/flimer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';

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

  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final iconList = <IconData>[
      Icons.home,
      Icons.image_rounded,
      Icons.person_rounded,
      Icons.power_settings_new,
    ];
    final List<Widget> _widgetOptions = <Widget>[
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Bienvenido(a)",
                  style: GoogleFonts.ubuntu(
                    fontSize: 30,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Image.asset(
                "assets/home.png",
                width: size.width * .9,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Text(
                  "Busca en tu galería o archivos una imagen que desees mejorar y déjanos el resto a nosotros.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    fontStyle: FontStyle.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const Text(
        'Módulo de Mejora de Imágenes',
      ),
      ProfileMobile(user: currentUser),
      const CircularProgressIndicator()
    ];

    return Scaffold(
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.orange,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.camera_alt_outlined),
            onTap: () {
              openCamera();
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.image),
            onTap: () async {
              final List<XFile>? files = await flimer.pickImages();
              if (files == null || files.isEmpty) {
                // Operation was canceled by the user.
                return;
              }

              // Aqui es donde vamos a mandar a la API
              print("Selected images : ${files.length}");
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: Colors.blue,
        activeColor: Colors.orange,
        splashColor: Colors.orangeAccent,
        icons: iconList,
        activeIndex: _currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() {
          _currentIndex = index;
          if (_currentIndex == 3) {
            logOut(context);
          }
        }),
      ),
      body: Container(
        child: Center(
          child: _widgetOptions.elementAt(_currentIndex),
        )
      ),
    );
  }

  Future<void> logOut(BuildContext context) async {
    _googleService.signOut().then(
      (value) => {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomeMobile(),
          ),
        ),
      },
    );
  }

  void openCamera() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CameraCamera(
              onFile: (file) {
                print(file);
                Navigator.pop(context);
                setState(() {});
              },
            )));
  }


}