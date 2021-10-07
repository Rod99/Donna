import 'package:donna/pages/desktop/home_sreen_desktop.dart';
import 'package:donna/pages/mobile/on_boarding_mobile.dart';
import 'package:donna/pages/tablet/on_boarding_tablet.dart';
import 'package:donna/utils/responsive_layout.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges, 
          initialData: null
        ),
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider()
        )
      ],
      child: MaterialApp(
        title: 'Donna',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ResponsiveLayout(
            mobileBody: OnBoardingMobile(),
            tabletBody: OnBoardingTablet(),
            desktopBody: HomeScreenDesktop()
        ),
      ),
    );
  }
}
