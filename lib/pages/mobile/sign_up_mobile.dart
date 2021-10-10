import 'package:donna/pages/mobile/home_mobile.dart';
import 'package:donna/pages/mobile/login_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/constants.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpMobile extends StatefulWidget {
  const SignUpMobile({ Key? key }) : super(key: key);

  @override
  _SignUpMobileState createState() => _SignUpMobileState();
}

class _SignUpMobileState extends State<SignUpMobile> {
  final AuthenticationService _authService = getIt<AuthenticationService>();
  final GoogleSignInProvider _googleService = getIt<GoogleSignInProvider>();
  final StorageService _storageService = getIt<StorageService>();
  final _formKey2 = GlobalKey<FormState>();

  final nameValidator = MultiValidator([  
    RequiredValidator(errorText: 'El nombre es obligatorio.'),  
    MinLengthValidator(7, errorText: 'Debe contener al menos 4 caracteres.'),   
  ]);

  final passwordValidator = MultiValidator([  
    RequiredValidator(errorText: 'La contraseña es obligatoria.'),  
    MinLengthValidator(7, errorText: 'Debe contener al menos 7 caracteres.'),   
  ]);

  final emailValidator = MultiValidator([  
    RequiredValidator(errorText: 'El email es obligatorio.'),  
    EmailValidator(errorText: 'Ingresa un email válido.'),   
  ]);
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    final nameField = TextFormField(
      controller: nameController,
      validator: nameValidator,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: 'Nombre',
        hintText: 'Ingresa tu nombre de usuario',
      ),
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
    );

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
      textInputAction: TextInputAction.next,
    );

    final confirmPasswordField = TextFormField(
      controller: confirmPasswordController,
      validator: (val) => MatchValidator(
        errorText: 'Las contraseñas son diferentes.').validateMatch(val!, passwordController.text),
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.vpn_key),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        labelText: 'Confirmar contraseña',
        hintText: 'Escribe de nuevo tu contraseña',
      ),
      onSaved: (value) {
        confirmPasswordController.text = value!;
      },
      textInputAction: TextInputAction.done,
    );

    final loginButton = TextButton(
      onPressed: () {
        signUp(nameController.text.trim(), emailController.text.trim(), passwordController.text.trim());
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
        "Crear Cuenta",
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
                key: _formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/register.png",
                      width: size.width,
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Registrarse",
                        style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: primary
                        )
                      ),
                    ),
                    const SizedBox(height: 15),
                    nameField,
                    const SizedBox(height: 15),
                    emailField,
                    const SizedBox(height: 15),
                    passwordField,
                    const SizedBox(height: 15),
                    confirmPasswordField,
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "o regístrate con",
                          style: GoogleFonts.ubuntu(
                            fontSize: 12,
                          )
                        ),
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
                          "¿Ya tienes cuenta? ",
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
                                  return const LoginMobile();
                                },
                              )
                            );
                          },
                          child: Text(
                            "Inicia Sesión", 
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
  Future signUp(String name, String email, String password) async {
    if(_formKey2.currentState!.validate()){
      
      try {
        await _authService.signUp(name: name, email: email, password: password)
          .then((uid) => {
            saveUser(name),
          });
      } on FirebaseAuthException catch (e) {
        var message = '';
        switch (e.code) {
          case 'email-already-in-use':
            message = 'Este email ya pertenece a otra cuenta.';
            break;
          case 'invalid-email':
            message = 'Email inválido.';
            break;
          case 'operation-not-allowed':
            message = 'La autenticación con email no está activada.';
            break;
          case 'weak-password':
            message = 'Contraseña muy débil.';
            break;
          default:
        }
        Fluttertoast.showToast(msg: message);
      }
    }
  }

  saveUser(String name) async {
    final User? user = _authService.currentUser;
    print('Usuario loggeado: ${user.toString()}');
    final UserModel userModel = UserModel(
      id: user!.uid.toString(),
      name: name,
      email: user.email,
      imageUrl: "https://avatar.oxro.io/avatar.svg?size=128&background=ff9a00&color=fff&name=${name.substring(0, 2)}"
    );

    try {
      await _storageService.createUser(userModel).then((value) => {
        Fluttertoast.showToast(msg: 'Cuenta creada exitosamente. ¡Bienvenido!'),
        Navigator.pushAndRemoveUntil( 
          (context), 
          MaterialPageRoute(builder: (context) => const HomeMobile()),
          (route) => false
        )
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Ocurrió un error al crear la cuenta: ${e.toString()}');
    }
  }
}