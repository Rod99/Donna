import 'package:donna/utils/constants.dart';
import 'package:donna/utils/mobile/login_wave.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpMobile extends StatelessWidget {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final passwordValidator = MultiValidator([  
    RequiredValidator(errorText: 'La contraseña es obligatoria'),  
    MinLengthValidator(8, errorText: 'La contraseña debe contener al menos 8 caracteres'),   
  ]);

  final emailValidator = MultiValidator([  
    RequiredValidator(errorText: 'El email es obligatorio'),  
    EmailValidator(errorText: 'Ingresa un email válido'),   
  ]);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 5),
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/register.png",
                      width: size.width,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Registrarse",
                          style: GoogleFonts.ubuntu(
                            fontSize: 30,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700,
                            color: primary
                          ),
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: TextFormField(
                          controller: nameController,
                          validator: RequiredValidator(errorText: 'El nombre es obligatorio'),
                          decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre',
                          hintText: 'Ingresa tu nombre de usuario'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: TextFormField(
                          controller: emailController,
                          validator: emailValidator,
                          decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          hintText: 'Ingresa tu correo electrónico',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: TextFormField(
                          controller: passwordController,
                          validator: passwordValidator,
                          obscureText: true,
                          decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                          hintText: 'Ingresa tu contraseña'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "o regístrate con",
                          style: GoogleFonts.ubuntu(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xff898A8D),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                            onPressed: () {
                              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                              provider.googleLogin();
                            },
                          ),
                        ),
                      ),
                    ),
                    Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: TextButton(
                        onPressed: () {
                          context.read<AuthenticationService>().signUp(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(), 
                            password: passwordController.text.trim()
                          );
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
                          "Crear cuenta",
                          style: TextStyle(color: primary),
                        ),
                      ),
                    ),
                  )
                  ],
                )
              ],
            ),
          ],
        )
      )
    );
  }
}
