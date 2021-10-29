import 'package:donna/pages/mobile/profile_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/constants.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel usuario;
  const EditProfilePage({ Key? key, required this.usuario }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final StorageService _storageService = getIt<StorageService>();
  final AuthenticationService _authService = getIt<AuthenticationService>();
  final _formKey3 = GlobalKey<FormState>();
  
  late final TextEditingController emailController;
  late final TextEditingController nameController;

  UserModel newUser = UserModel();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.usuario.email);
    nameController = TextEditingController(text: widget.usuario.name);
  }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final nameValidator = MultiValidator([  
      RequiredValidator(errorText: 'El nombre es obligatorio.'),  
      MinLengthValidator(7, errorText: 'Debe contener al menos 4 caracteres.'),   
    ]);

    final emailValidator = MultiValidator([  
      RequiredValidator(errorText: 'El email es obligatorio'),  
      EmailValidator(errorText: 'Ingresa un email válido'),   
    ]);
    
    final nameField = TextFormField(
      controller: nameController,
      validator: nameValidator,
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
      readOnly: true,
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
      textInputAction: TextInputAction.done,
    );

    final saveButton = ElevatedButton(
      onPressed: () {
        final UserModel newUserData = UserModel(
          id: widget.usuario.id,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          imageUrl: "https://ui-avatars.com/api/?background=ff9a00&color=fff&size=128&name=${nameController.text.trim().toUpperCase().substring(0, 1)}+${nameController.text.trim().toUpperCase().substring(1, 2)}"
        );
        // Navigator.pop(context, UserModel(name: "Samuel", email: "huevos@gmail.com", imageUrl: "https://ui-avatars.com/api/?background=ff9a00&color=fff&size=128&name=S+A"));
        saveChanges(newUserData);
      },
      style: ElevatedButton.styleFrom(
        primary: primary,
        padding: const EdgeInsets.only(
          left: 35,
          top: 20,
          right: 35,
          bottom: 20,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
          "Guardar Cambios",
        style: GoogleFonts.ubuntu(
          fontSize: 16,
          color: Colors.white
        ),
      ),
    );
    
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.usuario.imageUrl!),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Editar Perfil",
                        style: GoogleFonts.ubuntu(
                          fontSize: 30,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w700,
                          color: secondary
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    nameField,
                    const SizedBox(height: 20),
                    emailField,
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: (){
                          _passwordResetDialog(context);
                        },
                        child: Text(
                          "Actualizar contraseña", 
                          style: GoogleFonts.ubuntu(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            color: secondary
                          )
                        )
                      ),
                    ),
                    const SizedBox(height: 20),
                    saveButton,
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future saveChanges(UserModel newUserData) async {
    if(_formKey3.currentState!.validate()){
      print('Aquí estoy: ${newUserData.toString()}');
      await _storageService.updateUser(newUserData.toMap()).then((value) => {
        print(newUserData.id! + newUserData.email! + newUserData.imageUrl! + newUserData.name!),
        Navigator.pop(context, newUserData)
      });
    }
  }

  void _passwordResetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: const Text("¿Estás seguro que quieres cambiar tu contraseña?"),
        content: Text("Se enviará un email a ${widget.usuario.email} con el cual podrá actualizar su contraseña."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            }, 
            style: ElevatedButton.styleFrom(
              primary: primary,
              onPrimary: Colors.white,
              textStyle: const TextStyle(color: Colors.white),
            ),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.resetPassword(email: widget.usuario.email!).then((value) => {
                Navigator.pop(context)
              });
            },
            style: ElevatedButton.styleFrom(
              primary: secondary,
              onPrimary: Colors.white,
              textStyle: const TextStyle(color: Colors.white),
            ), 
            child: const Text("Confirmar"),
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      )
    );
  }
}