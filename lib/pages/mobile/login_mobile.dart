import 'package:donna/utils/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginMobile extends StatelessWidget {
  //const LoginMobile({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Text(
              'Hola, soy el login',
              style: GoogleFonts.ubuntu(),
            ),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: "Email",
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: "Password",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: const Text("Entrar"),
          ),
          ElevatedButton.icon(
            onPressed: () {  
              final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            }, 
            label: const Text('Iniciar sesión con Google'),
            icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
          )
        ],
      )
    );
  }
}
