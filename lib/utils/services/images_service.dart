import 'dart:async';
import 'dart:convert';

import 'package:donna/utils/models/images.dart';
import 'package:http/http.dart' as http;

class ImageService {
  Future<List<String>> uploadImages(List<String> images) async {
     //show your own loading or progressing code here

    String uploadurl = "http://7dd7-2806-2f0-9080-f2f-49b2-863e-7ac0-540.ngrok.io/upload";

    try{
      final response = await http.post(
        Uri.parse(uploadurl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode({
          'images': images,
        }),
      );

      print(response);
      if(response.statusCode == 200){
        // final jsondata = json.decode(response.body); //decode json data
        // RETURN IMÁGENES
        print("Envío exitoso de las imágenes");
        final imagesJson = jsonDecode(response.body)['images'];
        List<String> imagesList = imagesJson!=null?List.from(imagesJson as Iterable<dynamic>):[];
        return imagesList;
      }else{
        print(response.toString());
        return [];
      }
    }catch(e){
      print("Error al enviar las imágenes");
      print(e);
      return [];
    }
  }
}
