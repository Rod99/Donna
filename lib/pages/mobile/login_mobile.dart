import 'package:donna/pages/mobile/home_mobile.dart';
import 'package:donna/pages/mobile/sign_up_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/constants.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({ Key? key }) : super(key: key);

  @override
  _LoginMobileState createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final AuthenticationService _authService = getIt<AuthenticationService>();
  final GoogleSignInProvider _googleService = getIt<GoogleSignInProvider>();
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final passwordValidator = MultiValidator([  
      RequiredValidator(errorText: 'La contraseña es obligatoria'),  
      MinLengthValidator(7, errorText: 'La contraseña contiene al menos 7 caracteres'),   
    ]);

    final emailValidator = MultiValidator([  
      RequiredValidator(errorText: 'El email es obligatorio'),  
      EmailValidator(errorText: 'Ingresa un email válido'),   
    ]);
    
    final emailField = TextFormField(
      controller: emailController,
      validator: emailValidator,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.mail),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: 'Email',
        hintText: 'Ingresa tu correo electrónico',
      ),
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

    final passwordField = TextFormField(
      controller: passwordController,
      validator: passwordValidator,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: 'Contraseña',
        hintText: 'Ingresa tu contraseña',
      ),
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    final loginButton = TextButton(
      onPressed: () {
        login(emailController.text.trim(), passwordController.text.trim());
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.only(
          left: 35,
          top: 20,
          right: 35,
          bottom: 20,
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: const Text(
        "Iniciar sesión",
        style: TextStyle(color: primary),
      ),
    );
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/login.png",
                      width: size.width,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Iniciar Sesión",
                        style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: primary
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 20),
                    passwordField,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "o regístrate con",
                          style: GoogleFonts.ubuntu(
                            fontSize: 12,
                          )
                        ),
                        GestureDetector(
                          onTap: (){
                            
                          },
                          child: Text(
                            "¿Olvidaste tu contraseña?", 
                            style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: primary
                            )
                          )
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Ink(
                        decoration: const ShapeDecoration(
                          shape: CircleBorder(),
                          color: Colors.red,
                        ),
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.google
                          ),
                          color: Colors.white,
                          onPressed: () async {
                            await _googleService.googleLogin().then(
                              (value) => {
                                if(value != null){
                                  Navigator.pushAndRemoveUntil( 
                                    (context), 
                                    MaterialPageRoute(builder: (context) => const HomeMobile()),
                                    (route) => false
                                  )
                                }
                              }
                            );
                          },
                        ),
                      ),
                    ),
                    loginButton,
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿No tienes cuenta? ",
                          style: GoogleFonts.ubuntu(
                            fontSize: 12,
                          )
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).pop();
                            Navigator.push(
                              context, 
                              PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (context, animation, animationTime, child) {
                                  animation = CurvedAnimation(
                                    parent: animation,
                                    curve: Curves.elasticOut,
                                  );
                                  return ScaleTransition(
                                    alignment: Alignment.bottomCenter,
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (context, animation, animationTime) {
                                  return const SignUpMobile();
                                },
                              )
                            );
                          },
                          child: Text(
                            "Regístrate", 
                            style: GoogleFonts.ubuntu(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w600,
                              color: primary
                            )
                          )
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future login(String email, String password) async {
    if(_formKey.currentState!.validate()){
      
      try {
        await _authService.signIn(email: email, password: password)
          .then((uid) => {
            Fluttertoast.showToast(msg: 'Inicio de sesión exitoso. ¡Bienvenido!'),
            Navigator.pushAndRemoveUntil( 
              (context), 
              MaterialPageRoute(builder: (context) => const HomeMobile()),
              (route) => false
            )
          });
      } on FirebaseAuthException catch (e) {
        var message = '';
        switch (e.code) {
          case 'invalid-email':
            message = 'El email no es un email válido.';
            break;
          case 'user-disabled':
            message = 'Este usuario fue inhabilitado.';
            break;
          case 'user-not-found':
            message = 'No existe ninguna cuenta con este email.';
            break;
          case 'wrong-password':
            message = 'Contraseña incorrecta.';
            break;
          default:
        }
        Fluttertoast.showToast(msg: message);
      }
    }
  }
}