import 'package:donna/service_locator.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future signIn({required String email, required String password}) async{
    return _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future signUp({required String name, required String email, required String password}) async{
    return _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future resetPassword({required String email}) async {
    try {
      final response = await _firebaseAuth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(msg: "Se envió un email de cambio de contraseña al correo electrónico proporcionado.", timeInSecForIosWeb: 4);
      return response;
    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'invalid-email':
          message = 'El email proporcionado no es un email válido.';
          break;
        case 'user-not-found':
          message = 'No fue encontrado ningún usuario con este correo electrónico. Por favor crea una cuenta.';
          break;
        case 'missing-continue-uri':
          message = 'Un URL continuo debe ser provisto en la petición.';
          break;
        case 'unauthorized-continue-uri':
          message = 'El dominio del URL continuo no está en los dominios permitidos, ingrésalo a la whitelist de Firebase.';
          break;
        default:
      }
      Fluttertoast.showToast(msg: message, timeInSecForIosWeb: 4);
    }
  }
}

class GoogleSignInProvider extends ChangeNotifier {
  final StorageService _storageService = getIt<StorageService>();
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if(googleUser == null) return null;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken
      );

      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final UserModel userModel = UserModel(
        id: authResult.user?.uid,
        name: googleUser.displayName,
        email: googleUser.email,
        imageUrl: googleUser.photoUrl
      );
      _storageService.createUser(userModel);
      Fluttertoast.showToast(msg: 'Inicio de sesión con Google exitoso. ¡Bienvenido!');
      return authResult;
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error al iniciar sesión con Google. No pudo crearse la cuenta, inténtelo nuevamente');
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

