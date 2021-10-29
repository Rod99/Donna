import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ImageService {
  Future<void> uploadImages(List<String> images) async {
     //show your own loading or progressing code here
    print(images);

    String uploadurl = "/url/upload";

    try{
      final response = await http.post(
        Uri.parse(uploadurl), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {
          'images': images,
        },
      );

      if(response.statusCode == 200){
        final jsondata = json.decode(response.body); //decode json data
        // RETURN IMÁGENES
        print("Envío exitoso de las imágenes");
      }else{
        print(response.toString());
      }
    }catch(e){
      print("Error al enviar las imágenes");
    }
  }
}
