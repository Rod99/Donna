import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:camera_camera/camera_camera.dart';
import 'package:donna/pages/mobile/profile_mobile.dart';
import 'package:donna/pages/mobile/welcome_mobile.dart';
import 'package:donna/service_locator.dart';
import 'package:donna/utils/constants.dart';
import 'package:donna/utils/models/user.dart';
import 'package:donna/utils/services/auth_service.dart';
import 'package:donna/utils/services/images_service.dart';
import 'package:donna/utils/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flimer/flimer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcard/tcard.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({ Key? key }) : super(key: key);

  @override
  _HomeMobileState createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {

  final AuthenticationService _authService = getIt<AuthenticationService>();
  final GoogleSignInProvider _googleService = getIt<GoogleSignInProvider>();
  final StorageService _storageService = getIt<StorageService>();
  final ImageService _imageService = getIt<ImageService>();

  bool isUploading = false;
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
        backgroundColor: secondary,
        foregroundColor: Colors.white,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.camera_alt_outlined, color: Colors.white),
            onTap: () {
              openCamera();
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.blue,
            child: const Icon(Icons.image, color: Colors.white),
            onTap: () async {
              final List<XFile>? files = await flimer.pickImages();
              if (files == null || files.isEmpty) {
                // Operation was canceled by the user.
                return;
              }

              improveImages(files);
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
      body: isUploading 
        ? Container(
          padding: EdgeInsets.all(16),
          color:  Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Mejorando Imágenes",
                    style: GoogleFonts.ubuntu(
                      fontSize: 30,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Image.asset(
                  "assets/upload.png",
                  width: size.width,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: CircularProgressIndicator(strokeWidth: 3, color: secondary,),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'Las imágenes que seleccionaste están siendo procesadas, por favor espera a que el proceso termine para observar el resultado.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  )
                ),
              ],
            ),
          ),
        )
        : Container(
          child: Center(
            child: _widgetOptions.elementAt(_currentIndex),
          )
        ,)
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
                Navigator.pop(context);
                improveImages(file);
                setState(() {});
              },
            )));
  }

  void improveImages(dynamic fotos) async {
    // Mostrar las imágenes que seleccionó y tal vez poner una opción de "Mejorar" y otra "Cancelar" en el dialog
    final List<String> imagesBase64 = [];

    if(fotos is List<XFile>){
      final List<XFile> photos = fotos;
      if (await showDialog(context: context, builder: (context) => MultipleImagesDisplay(photos)) == false) {
        return;
      }
      for (final image in photos) {
        final imageBytes = await image.readAsBytes();
        final imageBase64 = base64Encode(imageBytes);
        imagesBase64.add(imageBase64);
      }
    } else if (fotos is File) {
      final File photo = fotos;
      if (await showDialog(context: context, builder: (context) => SinglePhotoDisplay(photo)) == false) {
        return;
      }
      final imageBytes = await photo.readAsBytes();
      final imageBase64 = base64Encode(imageBytes);
      imagesBase64.add(imageBase64);
    } else {
      return;
    }    

    // Aqui es donde vamos a mandar a la API
    setState(() {
      isUploading = true;
    });

    final List<String> imagenes = await _imageService.uploadImages(imagesBase64);

    setState(() {
      isUploading = false;
    });

    // Proceso inverso para cuando se reciban
    final List<Image> images = [];

    if(imagenes.isNotEmpty){
      for (var i = 0; i < imagenes.length; i++) {
        final imageDecode = base64Decode(imagenes[i]);
        images.add(Image.memory(imageDecode));
      }

      // await showDialog(context: context, builder: (context) => MultipleBase64ImagesDisplay(images));
      await showDialog(
          context: context,
          builder: (context) => CardImagesDisplay(images, imagenes),
          barrierDismissible: false
      );
    } else {
      return;
    }
  }
}

class MultipleImagesDisplay extends StatelessWidget {
  /// The files containing the images
  final List<XFile> files;

  /// Default Constructor
  MultipleImagesDisplay(this.files);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Imágenes seleccionadas'),
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...files.map(
              (file) => Flexible(
                  child: kIsWeb
                      ? Image.network(file.path)
                      : Image.file(File(file.path))),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}

class SinglePhotoDisplay extends StatelessWidget {
  /// The files containing the images
  final File foto;

  /// Default Constructor
  SinglePhotoDisplay(this.foto);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Foto tomada'),
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: kIsWeb
                  ? Image.network(foto.path)
                  : Image.file(File(foto.path)),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Aceptar'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}

class MultipleBase64ImagesDisplay extends StatelessWidget {
  /// The files containing the images
  final List<Image> images;

  /// Default Constructor
  MultipleBase64ImagesDisplay(this.images);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Imágenes Procesadas'),
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ...images.map(
              (image) => Flexible(
                  child: image,),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cerrar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class CardImagesDisplay extends StatelessWidget {
  /// The files containing the images
  final List<Image> images;
  final List<String> images_base64;
  /// Default Constructor
  CardImagesDisplay(this.images, this.images_base64);
  
  final TCardController _controller = TCardController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TCard(
              controller: _controller,
              size: const Size(256, 256),
              onEnd: () {
                Navigator.pop(context);
              },
              onForward: (index, info) async {
                if(info.direction == SwipDirection.Right) {
                  bool permission = false;
                  if(await Permission.storage.isGranted){
                    permission = true;
                  } else {
                    final result = await Permission.storage.request();
                    if (result == PermissionStatus.granted) {
                      permission = true;
                    }
                  }
                  if(permission){
                    Uint8List bytes = base64.decode(images_base64[index-1]);
                    String dir = (await getExternalStorageDirectory())!.path;
                    File file = File(
                        "$dir/${DateTime.now().millisecondsSinceEpoch}.jpg",);
                    print(dir);
                    await file.writeAsBytes(bytes);
                    GallerySaver.saveImage(file.path).then((path) => print(path));
                  }
                }else{
                  return;
                }
              },
              cards: List.generate(
                images.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 17),
                          blurRadius: 23.0,
                          spreadRadius: -13.0,
                          color: Colors.black54,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: images[index],
                        ),
                      ],
                    ),
                  );
                }
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.delete_forever, color: Colors.white),
                  onPressed: () {
                    print("Swipe a la izquierda");
                    _controller.forward(direction: SwipDirection.Left);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 15,
                      bottom: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  label: Text(
                    "",
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.download, color: Colors.white),
                  onPressed: () {
                    print("Swipe a la derecha");
                    _controller.forward(direction: SwipDirection.Right);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 15,
                      bottom: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  label: Text(
                    "",
                    style: GoogleFonts.ubuntu(
                      fontSize: 16,
                      color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }
}
