import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({required String email, required String password}) async{
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Sign In";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }

  Future<String> signUp({required String email, required String password}) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Sign Up";
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    try {
      await GoogleSignIn().disconnect();
    } catch (e) {
      print(e.toString());
    }
    await FirebaseAuth.instance.signOut();
  }
}

