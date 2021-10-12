import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:donna/pages/mobile/profile_mobile.dart';
import 'package:donna/pages/mobile/welcome_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/home.png",
            width: size.width * .9,
          ),
        ],
      ),
      const Text(
        'Index 1: Galeria',
      ),
      ProfileMobile(currentUser.name, currentUser.email)
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
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.image),
            onTap: () {
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


}